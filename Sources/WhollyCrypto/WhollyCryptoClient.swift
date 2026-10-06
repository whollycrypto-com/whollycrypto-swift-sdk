import Foundation

/// Merchant public API client. Keep credentials on a trusted backend or in a merchant-owned management app.
public struct WhollyCryptoClient: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    let http: HTTPClient
    public var description: String { "WhollyCryptoClient()" }
    public var debugDescription: String { description }
    public init(baseURL: String, apiToken: String, configuration: ClientConfiguration = .init()) throws {
        guard !apiToken.hasPrefix("wc_operator_") else { throw SDKError.validation("Use OperatorClient for Operator credentials.") }
        http = try HTTPClient(baseURL: baseURL, token: apiToken, configuration: configuration)
    }
    init(http: HTTPClient) { self.http = http }
    /// Generate ONCE and persist with the payload before creating an invoice. Reuse on uncertain retries.
    public static func newIdempotencyKey() -> String { UUID().uuidString.lowercased() }
    private func project(_ id: UUID) -> String { "/v1/projects/" + id.uuidString.lowercased() }
    private func store(_ projectID: UUID, _ storeID: UUID) -> String { project(projectID) + "/stores/" + storeID.uuidString.lowercased() }

    public func serviceInfo() async throws -> APIResponse { try await http.request("GET", "/", authenticated: false) }
    public func health() async throws -> APIResponse { try await http.request("GET", "/healthz", authenticated: false) }
    public func createInvoice(projectID: UUID, storeID: UUID, invoice: InvoiceCreateRequest, idempotencyKey: String) async throws -> APIResponse {
        try await http.request("POST", store(projectID, storeID) + "/invoices", body: invoice.json(), idempotencyKey: idempotencyKey)
    }
    public func getInvoice(projectID: UUID, invoiceID: UUID) async throws -> APIResponse {
        try await http.request("GET", project(projectID) + "/invoices/" + invoiceID.uuidString.lowercased())
    }
    public func listInvoices(projectID: UUID, filters: [String: String] = [:]) async throws -> APIResponse {
        try await http.request("GET", project(projectID) + "/invoices", query: filters)
    }
    public func listInvoicePayments(projectID: UUID, invoiceID: UUID, filters: [String: String] = [:]) async throws -> APIResponse {
        try await http.request("GET", project(projectID) + "/invoices/" + invoiceID.uuidString.lowercased() + "/payments", query: filters)
    }
    public func listProjectPaymentAssets(projectID: UUID) async throws -> APIResponse {
        try await http.request("GET", project(projectID) + "/payment-assets")
    }
    public func updateProjectPaymentAsset(projectID: UUID, assetID: UUID, policy: [String: JSONValue]) async throws -> APIResponse {
        try await http.request("PUT", project(projectID) + "/payment-assets/" + assetID.uuidString.lowercased(), body: .object(policy))
    }
    public func listTokenCandidates(projectID: UUID, chainSlug: String, filters: [String: String] = [:]) async throws -> APIResponse {
        var query = filters; query["chain_slug"] = chainSlug
        return try await http.request("GET", project(projectID) + "/payment-token-candidates", query: query)
    }
    public func registerTokenAsset(projectID: UUID, token: [String: JSONValue]) async throws -> APIResponse {
        try await http.request("POST", project(projectID) + "/payment-token-assets", body: .object(token))
    }
    public func discoverCustomDexPools(projectID: UUID, chainSlug: String, contractAddress: String) async throws -> APIResponse {
        try await http.request("GET", project(projectID) + "/payment-token-dex-pools", query: ["chain_slug": chainSlug, "contract_address": contractAddress])
    }
    public func registerCustomToken(projectID: UUID, token: [String: JSONValue]) async throws -> APIResponse {
        if let value = token["price_usd"], value != .null {
            guard let string = value.stringValue else { throw SDKError.validation("price_usd must be a decimal string.") }
            try validateDecimal(string)
        }
        return try await http.request("POST", project(projectID) + "/payment-token-assets/custom", body: .object(token))
    }
    public func listStorePaymentAssets(projectID: UUID, storeID: UUID) async throws -> APIResponse {
        try await http.request("GET", store(projectID, storeID) + "/payment-assets")
    }
    /// Replaces ALL accepted on-chain assets. An empty array clears them; Lightning is separate.
    public func updateStorePaymentAssets(projectID: UUID, storeID: UUID, assets: [[String: JSONValue]]) async throws -> APIResponse {
        try await http.request("PUT", store(projectID, storeID) + "/payment-assets", body: ["assets": .array(assets.map(JSONValue.object))])
    }
    public func updateStoreConfirmationPolicy(projectID: UUID, storeID: UUID, assetID: UUID, policy: [String: JSONValue]) async throws -> APIResponse {
        try await http.request("PUT", store(projectID, storeID) + "/payment-assets/" + assetID.uuidString.lowercased() + "/confirmation-policy", body: .object(policy))
    }
    public func listProjectWallets(projectID: UUID) async throws -> APIResponse { try await http.request("GET", project(projectID) + "/wallets") }
    public func listReconciliation(projectID: UUID, filters: [String: String] = [:]) async throws -> APIResponse {
        try await http.request("GET", project(projectID) + "/reconciliation", query: filters)
    }
    public func getReconciliation(projectID: UUID, invoiceID: UUID, page: Int = 1) async throws -> APIResponse {
        guard page >= 1 else { throw SDKError.validation("Page starts at 1.") }
        return try await http.request("GET", project(projectID) + "/reconciliation/" + invoiceID.uuidString.lowercased(), query: ["page": String(page)])
    }

    /// Lazy, cancellation-aware pagination. Does not fetch the next page until requested.
    public func invoices(projectID: UUID, filters: [String: String] = [:], pageSize: Int = 50) throws -> InvoiceSequence {
        guard (1...100).contains(pageSize), filters["offset"] == nil, filters["limit"] == nil else { throw SDKError.validation("Use pageSize (1–100); pagination starts at offset zero.") }
        return InvoiceSequence(client: self, projectID: projectID, filters: filters, pageSize: pageSize)
    }
}

public struct InvoiceSequence: AsyncSequence, Sendable {
    public typealias Element = Invoice
    let client: WhollyCryptoClient
    let projectID: UUID
    let filters: [String: String]
    let pageSize: Int
    public func makeAsyncIterator() -> AsyncIterator { AsyncIterator(sequence: self) }
    public struct AsyncIterator: AsyncIteratorProtocol {
        let sequence: InvoiceSequence
        var buffer: [Invoice] = []
        var index = 0
        var offset = 0
        var finished = false
        public mutating func next() async throws -> Invoice? {
            try Task.checkCancellation()
            if index < buffer.count { defer { index += 1 }; return buffer[index] }
            if finished { return nil }
            var query = sequence.filters
            query["offset"] = String(offset); query["limit"] = String(sequence.pageSize)
            let response = try await sequence.client.listInvoices(projectID: sequence.projectID, filters: query)
            guard let data = response.json["data"]?.arrayValue, let pagination = response.json["pagination"],
                  pagination["offset"]?.intValue == offset, pagination["limit"]?.intValue == sequence.pageSize,
                  let more = pagination["has_more"]?.boolValue, data.count <= sequence.pageSize,
                  !more || (!data.isEmpty && offset + sequence.pageSize <= 1_000_000) else { throw SDKError.invalidResponse("Invoice pagination cannot advance safely.") }
            buffer = try data.map { value in guard let invoice = Invoice(value) else { throw SDKError.invalidResponse("Invalid invoice list item.") }; return invoice }
            index = 0; finished = !more; offset += sequence.pageSize
            guard !buffer.isEmpty else { return nil }
            index = 1
            return buffer[0]
        }
    }
}
