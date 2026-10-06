import Foundation

/// Trusted-server Marketplace API. Payout keys must never ship in an iOS app.
public struct MarketplaceClient: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    let http: HTTPClient
    public var description: String { "WhollyCrypto.MarketplaceClient()" }
    public var debugDescription: String { description }
    public init(baseURL: String, apiToken: String, configuration: ClientConfiguration = .init()) throws {
        guard apiToken.range(of: #"\Awc_marketplace_[a-f0-9]{32}_[a-f0-9]{64}\z"#, options: .regularExpression) != nil else { throw SDKError.validation("Use a separate scoped Marketplace API key.") }
        http = try HTTPClient(baseURL: baseURL, token: apiToken, configuration: configuration)
    }
    init(http: HTTPClient) { self.http = http }
    func read(_ projectID: UUID, _ path: String, query: [String: String]) async throws -> APIResponse {
        var query = query
        let id = projectID.uuidString.lowercased()
        guard query["project_id"] == nil || query["project_id"] == id else { throw SDKError.validation("Conflicting project_id.") }
        query["project_id"] = id
        return try await http.request("GET", path, query: query)
    }
    private func money(_ body: [String: JSONValue]) throws {
        for (key,value) in body where value != .null {
            if ["amount","gross_amount","commission_percent","exchange_rate_spread_percent","underpayment_tolerance_percent"].contains(key) {
                guard let amount = value.stringValue else { throw SDKError.validation("Amounts must be exact decimal strings.") }
                try validateDecimal(amount)
            }
            if key.hasSuffix("_atomic") {
                guard let amount = value.stringValue, amount.range(of: #"\A(?:0|[1-9][0-9]{0,77})\z"#, options: .regularExpression) != nil else { throw SDKError.validation("Atomic amounts must be exact nonnegative integer strings.") }
            }
        }
        for key in ["allocations","stores"] {
            if let value = body[key] {
                guard case let .array(rows) = value else { throw SDKError.validation("Expected a list.") }
                for row in rows {
                    guard let object = row.objectValue else { throw SDKError.validation("Expected an object.") }
                    try money(object)
                }
            }
        }
    }
    func write(_ projectID: UUID, _ path: String, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        guard idempotencyKey.range(of: #"\A[A-Za-z0-9_.-]{16,128}\z"#, options: .regularExpression) != nil else { throw SDKError.validation("Persist a 16–128 character idempotency key before sending.") }
        var body = body
        let id = projectID.uuidString.lowercased()
        guard body["project_id"] == nil || body["project_id"] == .string(id) else { throw SDKError.validation("Conflicting project_id.") }
        body["project_id"] = .string(id)
        try money(body)
        return try await http.request("POST", path, body: .object(body), idempotencyKey: idempotencyKey)
    }
}
