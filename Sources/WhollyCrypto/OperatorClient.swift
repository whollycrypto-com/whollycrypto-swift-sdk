import Foundation

/// Separate, scoped Operator API. Never embed Operator credentials in customer apps.
public struct OperatorClient: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    let http: HTTPClient
    public var description: String { "WhollyCrypto.OperatorClient()" }
    public var debugDescription: String { description }
    public init(baseURL: String, apiToken: String, configuration: ClientConfiguration = .init()) throws {
        guard apiToken.range(of: #"\Awc_operator_[a-f0-9]{32}_[a-f0-9]{64}\z"#, options: .regularExpression) != nil else {
            throw SDKError.validation("Use a separate Operator API credential, not a merchant credential.")
        }
        http = try HTTPClient(baseURL: baseURL, token: apiToken, configuration: configuration)
    }
    init(http: HTTPClient) { self.http = http }
    func write(_ path: String, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        guard idempotencyKey.range(of: #"\A[A-Za-z0-9_.-]{16,128}\z"#, options: .regularExpression) != nil else { throw SDKError.validation("Operator writes require a persisted 16–128 character idempotency key (letters, digits, _, . or -).") }
        for key in ["amount", "starting_credit"] {
            if let value = body[key], value != .null {
                guard let string = value.stringValue else { throw SDKError.validation("Operator amounts must be decimal strings.") }
                try validateDecimal(string, signed: path.hasSuffix("/credits/adjustments") && key == "amount")
            }
        }
        return try await http.request("POST", path, body: .object(body), idempotencyKey: idempotencyKey)
    }
}

/// Invitation-token-only onboarding. Never carries an API credential or automatically retries acceptance.
public struct OnboardingClient: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    let http: HTTPClient
    public var description: String { "WhollyCrypto.OnboardingClient()" }
    public var debugDescription: String { description }
    public init(baseURL: String, configuration: ClientConfiguration = .init()) throws {
        http = try HTTPClient(baseURL: baseURL, token: nil, configuration: configuration)
    }
    init(http: HTTPClient) { self.http = http }
    public func checkInvitation(token: String) async throws -> APIResponse {
        try validateInvitationToken(token)
        return try await http.request("POST", "/v1/onboarding/invitations/check", body: ["token": .string(token)], authenticated: false)
    }
    public func acceptInvitation(token: String, password: String, custodyAcknowledged: Bool) async throws -> APIResponse {
        try validateInvitationToken(token)
        guard custodyAcknowledged else { throw SDKError.validation("The person accepting must explicitly acknowledge Operator custody.") }
        guard !password.isEmpty, password.utf8.count <= 4096 else { throw SDKError.validation("Enter the user's chosen password; server password policy also applies.") }
        return try await http.request("POST", "/v1/onboarding/invitations/accept", body: ["token": .string(token), "password": .string(password), "custody_acknowledged": .bool(true)], authenticated: false)
    }
    private func validateInvitationToken(_ token: String) throws {
        guard !token.isEmpty, token.utf8.count <= 4096, token.utf8.allSatisfy({ (33...126).contains($0) }) else { throw SDKError.validation("Pass the invitation token, not the full link.") }
    }
}
