import Foundation

/// A JSON number's exact wire representation. Money in the API is a *string*, not a number.
public struct JSONNumber: Sendable, Equatable {
    public let rawValue: String
    public init(_ value: String) throws {
        guard value.utf8.count <= 256, value.range(of: #"\A-?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?\z"#, options: .regularExpression) != nil else {
            throw SDKError.validation("Invalid JSON number.")
        }
        rawValue = value
    }
}

/// Lossless JSON. No implicit Double conversion; unknown response fields remain accessible.
public indirect enum JSONValue: Sendable, Equatable {
    case object([String: JSONValue]), array([JSONValue]), string(String), number(JSONNumber), bool(Bool), null

    public subscript(_ key: String) -> JSONValue? { objectValue?[key] }
    public var objectValue: [String: JSONValue]? { if case .object(let v) = self { return v }; return nil }
    public var arrayValue: [JSONValue]? { if case .array(let v) = self { return v }; return nil }
    public var stringValue: String? { if case .string(let v) = self { return v }; return nil }
    public var boolValue: Bool? { if case .bool(let v) = self { return v }; return nil }
    public var numberString: String? { if case .number(let v) = self { return v.rawValue }; return nil }
    public var intValue: Int? { numberString.flatMap(Int.init) }

    public static func parse(_ data: Data, maximumBytes: Int = 4_194_304) throws -> JSONValue {
        guard maximumBytes > 0, data.count <= maximumBytes else { throw SDKError.invalidResponse("JSON exceeds the size limit.") }
        var parser = JSONParser(bytes: Array(data))
        let value = try parser.value(depth: 0)
        parser.whitespace()
        guard parser.index == parser.bytes.count else { throw SDKError.invalidResponse("Unexpected bytes after JSON.") }
        return value
    }

    /// Stable object-key ordering preserves exact retry bytes when reusing an idempotency key.
    public func encoded() throws -> Data { Data(try render(depth: 0).utf8) }
    private func render(depth: Int) throws -> String {
        guard depth <= 64 else { throw SDKError.validation("JSON nesting exceeds 64 levels.") }
        func quoted(_ string: String) throws -> String {
            String(decoding: try JSONEncoder().encode(string), as: UTF8.self)
        }
        switch self {
        case .null: return "null"
        case .bool(let v): return v ? "true" : "false"
        case .string(let v): return try quoted(v)
        case .number(let v): return v.rawValue
        case .array(let v): return "[" + (try v.map { try $0.render(depth: depth + 1) }).joined(separator: ",") + "]"
        case .object(let v):
            return "{" + (try v.keys.sorted().map { key in try quoted(key) + ":" + v[key]!.render(depth: depth + 1) }).joined(separator: ",") + "}"
        }
    }
}
extension JSONValue: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral, ExpressibleByNilLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
    public init(integerLiteral value: Int64) { self = .number(try! JSONNumber(String(value))) }
    public init(booleanLiteral value: Bool) { self = .bool(value) }
    public init(nilLiteral: ()) { self = .null }
    public init(arrayLiteral elements: JSONValue...) { self = .array(elements) }
    public init(dictionaryLiteral elements: (String, JSONValue)...) { self = .object(Dictionary(elements, uniquingKeysWith: { _, last in last })) }
}

private struct JSONParser {
    let bytes: [UInt8]
    var index = 0
    mutating func whitespace() { while index < bytes.count && [9, 10, 13, 32].contains(bytes[index]) { index += 1 } }
    mutating func take(_ byte: UInt8) -> Bool {
        whitespace()
        if index < bytes.count && bytes[index] == byte { index += 1; return true }
        return false
    }
    mutating func string() throws -> String {
        whitespace()
        let start = index
        guard take(34) else { throw SDKError.invalidResponse("Expected a JSON string.") }
        while index < bytes.count {
            let b = bytes[index]; index += 1
            if b == 34 {
                do { return try JSONDecoder().decode(String.self, from: Data(bytes[start..<index])) }
                catch { throw SDKError.invalidResponse("Invalid JSON string.") }
            }
            if b == 92 { index += 1 }
        }
        throw SDKError.invalidResponse("Unterminated JSON string.")
    }
    mutating func value(depth: Int) throws -> JSONValue {
        guard depth <= 64 else { throw SDKError.invalidResponse("JSON nesting exceeds 64 levels.") }
        whitespace()
        guard index < bytes.count else { throw SDKError.invalidResponse("Expected JSON.") }
        switch bytes[index] {
        case 34: return .string(try string())
        case 123:
            index += 1
            var object: [String: JSONValue] = [:]
            if take(125) { return .object(object) }
            repeat {
                let key = try string()
                guard object[key] == nil, take(58) else { throw SDKError.invalidResponse("Duplicate key or invalid JSON object.") }
                object[key] = try value(depth: depth + 1)
                if take(125) { return .object(object) }
            } while take(44)
            throw SDKError.invalidResponse("Invalid JSON object.")
        case 91:
            index += 1
            var values: [JSONValue] = []
            if take(93) { return .array(values) }
            repeat {
                values.append(try value(depth: depth + 1))
                if take(93) { return .array(values) }
            } while take(44)
            throw SDKError.invalidResponse("Invalid JSON array.")
        default:
            let start = index
            while index < bytes.count && ![9, 10, 13, 32, 44, 93, 125].contains(bytes[index]) { index += 1 }
            let token = String(decoding: bytes[start..<index], as: UTF8.self)
            switch token {
            case "null": return .null
            case "true": return .bool(true)
            case "false": return .bool(false)
            default:
                do { return .number(try JSONNumber(token)) }
                catch { throw SDKError.invalidResponse("Invalid JSON value.") }
            }
        }
    }
}
