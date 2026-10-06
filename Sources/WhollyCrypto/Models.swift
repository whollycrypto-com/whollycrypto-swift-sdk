import Foundation

public enum SDKError: Error, LocalizedError, CustomStringConvertible, Sendable {
    case validation(String), invalidResponse(String), transport, invalidSignature, responseTooLarge, redirectRefused
    public var description: String {
        switch self {
        case .validation(let m), .invalidResponse(let m): return m
        case .transport: return "The request could not be completed. A failed connection does not prove that a write failed."
        case .invalidSignature: return "Invalid, expired or malformed notification signature or payload."
        case .responseTooLarge: return "The response exceeded the configured size limit."
        case .redirectRefused: return "API redirects are not followed. Use the final HTTPS API origin."
        }
    }
    public var errorDescription: String? { description }
}

public struct APIResponse: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    public let json: JSONValue
    public let statusCode: Int
    public let headers: [String: String]
    /// Explicit diagnostics only. May contain customer information. Never log by default.
    public let rawBody: Data
    public var description: String { "WhollyCrypto.APIResponse(HTTP \(statusCode))" }
    public var debugDescription: String { description }
    public var invoice: Invoice? { json["data"].flatMap(Invoice.init) }
    public var checkoutURL: URL? {
        guard let raw = json["links"]?["checkout"]?.stringValue, let url = URL(string: raw), url.scheme == "https", url.host != nil, url.user == nil, url.password == nil else { return nil }
        return url
    }
    public var retryAfterSeconds: TimeInterval? {
        guard let raw = headers["retry-after"] else { return nil }
        if raw.range(of: #"\A[0-9]+\z"#, options: .regularExpression) != nil, let n = Double(raw), n.isFinite { return n }
        let date = DateFormatter(); date.locale = Locale(identifier: "en_US_POSIX"); date.timeZone = TimeZone(secondsFromGMT: 0)
        date.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss z"
        return date.date(from: raw).map { max(0, $0.timeIntervalSinceNow) }
    }
}

public struct Invoice: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    public let invoiceID: String
    public let status: String
    public let fields: JSONValue
    public var amount: String? { fields["amount"]?.stringValue }
    public var currency: String? { fields["currency"]?.stringValue }
    public var orderID: String? { fields["order_id"]?.stringValue }
    public var description: String { "WhollyCrypto.Invoice()" }
    public var debugDescription: String { description }
    public init?(_ value: JSONValue) {
        guard let id = value["invoice_id"]?.stringValue, UUID(uuidString: id) != nil,
              let status = value["status"]?.stringValue else { return nil }
        invoiceID = id; self.status = status; fields = value
    }
}

public struct APIError: Error, LocalizedError, CustomStringConvertible, CustomDebugStringConvertible, Sendable {
    public let response: APIResponse
    public var statusCode: Int { response.statusCode }
    public var code: String {
        let value = response.json["error"]?["code"]?.stringValue ?? "http_error"
        return value.range(of: #"\A[a-z][a-z0-9_]{0,79}\z"#, options: .regularExpression) != nil ? value : "http_error"
    }
    /// Opt-in private diagnostics, not suitable for public error pages or general logs.
    public var apiMessage: String? { response.json["error"]?["message"]?.stringValue }
    public var details: JSONValue? { response.json["error"]?["details"] }
    public var paymentMethodIssues: [JSONValue] { details?["payment_methods"]?.arrayValue ?? [] }
    public var retryAfterSeconds: TimeInterval? { response.retryAfterSeconds }
    public var description: String { "Wholly Crypto API returned HTTP \(statusCode) (\(code))." }
    public var debugDescription: String { description }
    public var errorDescription: String? { description }
}

public struct InvoicePaymentSelection: Sendable {
    public var chainSlug: String
    public var assetTickers: [String]?
    public var assetIDs: [UUID]?
    public var paymentRail: String?
    public init(chainSlug: String, assetTickers: [String]? = nil, assetIDs: [UUID]? = nil, paymentRail: String? = nil) {
        self.chainSlug = chainSlug; self.assetTickers = assetTickers; self.assetIDs = assetIDs; self.paymentRail = paymentRail
    }
    func json() throws -> JSONValue {
        guard chainSlug.range(of: #"\A[a-z0-9][a-z0-9-]{0,63}\z"#, options: .regularExpression) != nil,
              assetTickers == nil || assetIDs == nil else { throw SDKError.validation("Choose a chain and tickers OR asset UUIDs, not both.") }
        var result: [String: JSONValue] = ["chain_slug": .string(chainSlug)]
        if let values = assetTickers { result["asset_tickers"] = .array(values.map(JSONValue.string)) }
        if let values = assetIDs { result["asset_ids"] = .array(values.map { .string($0.uuidString.lowercased()) }) }
        if let rail = paymentRail { result["payment_rail"] = .string(rail) }
        return .object(result)
    }
}

public struct InvoiceCreateRequest: Sendable {
    public var amount: String
    public var currency: String
    public var orderID: String?
    public var email: String?
    public var description: String?
    public var ipnURL: String?
    public var redirectURL: String?
    public var cancelURL: String?
    public var language: String?
    public var metadata: [String: JSONValue]?
    public var checkoutAppearance: [String: JSONValue]?
    public var paymentMethods: [InvoicePaymentSelection]?
    public var exchangeRateSpreadPercent: String?
    public var underpaymentTolerancePercent: String?
    /// Future public fields. Known typed fields cannot be overwritten here.
    public var additionalFields: [String: JSONValue] = [:]
    public init(amount: String, currency: String) { self.amount = amount; self.currency = currency }
    public func json() throws -> JSONValue {
        try validateDecimal(amount)
        guard currency.range(of: #"\A[A-Z]{3}\z"#, options: .regularExpression) != nil else { throw SDKError.validation("Currency must be a three-letter uppercase fiat code.") }
        var result: [String: JSONValue] = ["amount": .string(amount), "currency": .string(currency)]
        for (key, value) in [("order_id", orderID), ("email", email), ("description", description), ("ipn_url", ipnURL), ("redirect_url", redirectURL), ("cancel_url", cancelURL), ("language", language)] {
            if let value { result[key] = .string(value) }
        }
        for (key, value) in [("exchange_rate_spread_percent", exchangeRateSpreadPercent), ("underpayment_tolerance_percent", underpaymentTolerancePercent)] {
            if let value { try validateDecimal(value); result[key] = .string(value) }
        }
        if let metadata { result["metadata"] = .object(metadata) }
        if let checkoutAppearance { result["checkout_appearance"] = .object(checkoutAppearance) }
        if let paymentMethods {
            guard !paymentMethods.isEmpty else { throw SDKError.validation("Omit paymentMethods to use store defaults; an empty list is invalid.") }
            result["payment_methods"] = .array(try paymentMethods.map { try $0.json() })
        }
        let known: Set<String> = ["amount", "currency", "order_id", "email", "description", "ipn_url", "redirect_url", "cancel_url", "language", "metadata", "checkout_appearance", "payment_methods", "exchange_rate_spread_percent", "underpayment_tolerance_percent"]
        guard known.isDisjoint(with: additionalFields.keys) else { throw SDKError.validation("Use the typed property for known invoice fields.") }
        result.merge(additionalFields) { first, _ in first }
        return .object(result)
    }
}

func validateDecimal(_ value: String, signed: Bool = false) throws {
    let pattern = signed ? #"\A-?[0-9]{1,48}(?:\.[0-9]{1,30})?\z"# : #"\A[0-9]{1,48}(?:\.[0-9]{1,30})?\z"#
    guard value.range(of: pattern, options: .regularExpression) != nil else { throw SDKError.validation("Amounts must be plain decimal strings; never use Double for money.") }
}
