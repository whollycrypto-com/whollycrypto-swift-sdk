import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import XCTest
@testable import WhollyCrypto

let fixtureID = UUID(uuidString: "11111111-1111-4111-8111-111111111111")!
let fixtureToken = "synthetic-test-token-not-a-credential"
actor MockTransport: HTTPTransport {
    var requests: [URLRequest] = []
    var responses: [WireResponse]
    init(response: WireResponse) { responses = [response] }
    init(responses: [WireResponse]) { self.responses = responses }
    func send(_ request: URLRequest, configuration: ClientConfiguration) async throws -> WireResponse {
        requests.append(request)
        guard !responses.isEmpty else { throw SDKError.transport }
        return responses.removeFirst()
    }
}
func testHTTP(_ mock: MockTransport) throws -> HTTPClient {
    try HTTPClient(baseURL: "https://api.example.test", token: fixtureToken, configuration: .init(), transport: mock)
}
func fixture(_ name: String) throws -> JSONValue {
    let url = Bundle.module.url(forResource: name, withExtension: "json", subdirectory: "Fixtures")!
    return try JSONValue.parse(Data(contentsOf: url))
}
func operatorFixture(_ name: String) throws -> JSONValue {
    try fixture("operator-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == name }!
}
func response(_ json: JSONValue, status: Int = 200, headers: [String: String] = [:]) throws -> WireResponse {
    WireResponse(status: status, headers: headers.merging(["content-type": "application/json"]) { first, _ in first }, body: try json.encoded())
}

final class CoreTests: XCTestCase {
    func testExactJSONAndDeterministicOrder() throws {
        let text = #"{"z":90071992547409931234567890,"money":"0.123456789012345678901234","a":1.12345678901234567890123456789012345678901234567890,"unicode":"日本語 😀"}"#
        let parsed = try JSONValue.parse(Data(text.utf8))
        XCTAssertEqual(parsed["z"]?.numberString, "90071992547409931234567890")
        XCTAssertEqual(parsed["a"]?.numberString, "1.12345678901234567890123456789012345678901234567890")
        XCTAssertEqual(try JSONValue.parse(parsed.encoded()), parsed)
        let first: JSONValue = ["b": 2, "a": "25.00"]
        let second: JSONValue = ["a": "25.00", "b": 2]
        XCTAssertEqual(try first.encoded(), second.encoded())
    }
    func testRejectMalformedJSON() {
        for text in [#"{"x":1,"x":2}"#, "[1,]", "{\"x\":1,}", "01", "+1", "NaN", "true garbage", #""\uD800""#, "1e", "", String(repeating: "[", count: 66) + "0" + String(repeating: "]", count: 66)] {
            XCTAssertThrowsError(try JSONValue.parse(Data(text.utf8)), text)
        }
        XCTAssertThrowsError(try JSONValue.parse(Data([0x22, 0xff, 0x22])))
    }
    func testInvoiceValidationAndSelection() throws {
        var request = InvoiceCreateRequest(amount: "25.00", currency: "EUR")
        request.paymentMethods = [.init(chainSlug: "ethereum", assetTickers: ["USDC", "USDT"]), .init(chainSlug: "solana")]
        request.metadata = ["order_number": "1001"]
        request.exchangeRateSpreadPercent = "0.5"
        XCTAssertEqual(try request.json()["amount"]?.stringValue, "25.00")
        XCTAssertNil(try request.json()["payment_methods"]?.arrayValue?[1]["asset_tickers"])
        for amount in ["1e2", "-1", "NaN", " 1", "1.", "1\n"] { request.amount = amount; XCTAssertThrowsError(try request.json()) }
        request.amount = "25.00"; request.paymentMethods = []
        XCTAssertThrowsError(try request.json())
        request.paymentMethods = [.init(chainSlug: "ethereum", assetTickers: ["ETH"], assetIDs: [fixtureID])]
        XCTAssertThrowsError(try request.json())
        request.paymentMethods = nil; request.additionalFields["amount"] = "1"
        XCTAssertThrowsError(try request.json())
    }
    func testOriginAndTokenBoundaries() throws {
        for url in ["http://api.example.test", "https://user:pass@example.test", "https://example.test/v1", "https://example.test/?q=1", "https://example.test/#x", " https://example.test", "https://example.test:0"] {
            XCTAssertThrowsError(try WhollyCryptoClient(baseURL: url, apiToken: fixtureToken), url)
        }
        for token in ["", "bad\r\nheader", "has space", "wc_operator_wrong"] { XCTAssertThrowsError(try WhollyCryptoClient(baseURL: "https://example.test", apiToken: token)) }
        XCTAssertThrowsError(try OperatorClient(baseURL: "https://example.test", apiToken: fixtureToken))
        var local = ClientConfiguration(); local.allowInsecureLocalhost = true
        XCTAssertNoThrow(try WhollyCryptoClient(baseURL: "http://127.0.0.1:8080", apiToken: fixtureToken, configuration: local))
        XCTAssertThrowsError(try WhollyCryptoClient(baseURL: "http://example.test", apiToken: fixtureToken, configuration: local))
    }
    func testDetailedErrorAndNoRetry() async throws {
        let body: JSONValue = ["error": ["code": "no_ready_payment_methods", "message": .string("Private detail " + fixtureToken), "details": ["payment_methods": [["chain_slug": "tron", "reason_code": "scanner_unavailable"]]]]]
        let mock = MockTransport(response: try response(body, status: 429, headers: ["retry-after": "4"]))
        do { _ = try await testHTTP(mock).request("POST", "/v1/test", body: [:], idempotencyKey: "test-key"); XCTFail("Expected error") }
        catch let error as APIError {
            XCTAssertEqual(error.statusCode, 429); XCTAssertEqual(error.code, "no_ready_payment_methods")
            XCTAssertEqual(error.retryAfterSeconds, 4); XCTAssertEqual(error.paymentMethodIssues.count, 1)
            XCTAssertFalse(error.apiMessage!.contains(fixtureToken)); XCTAssertFalse(error.description.contains("Private detail"))
            XCTAssertFalse(String(reflecting: error).contains(fixtureToken))
        }
        let requests = await mock.requests; XCTAssertEqual(requests.count, 1)
    }
    func testHeadersAndRetryBytes() async throws {
        let mock = MockTransport(responses: [try response([:]), try response([:]), try response([:])])
        let http = try testHTTP(mock)
        _ = try await http.request("GET", "/", authenticated: false)
        let key = WhollyCryptoClient.newIdempotencyKey()
        _ = try await http.request("POST", "/v1/test", body: ["amount": "25.00", "currency": "EUR"], idempotencyKey: key)
        _ = try await http.request("POST", "/v1/test", body: ["currency": "EUR", "amount": "25.00"], idempotencyKey: key)
        let requests = await mock.requests
        XCTAssertNil(requests[0].value(forHTTPHeaderField: "Authorization"))
        XCTAssertEqual(requests[1].value(forHTTPHeaderField: "Authorization"), "Bearer " + fixtureToken)
        XCTAssertEqual(requests[1].httpBody, requests[2].httpBody)
        XCTAssertEqual(requests[1].value(forHTTPHeaderField: "Idempotency-Key"), requests[2].value(forHTTPHeaderField: "Idempotency-Key"))
    }
    func testQueryEncoding() async throws {
        let mock = MockTransport(response: try response([:]))
        _ = try await testHTTP(mock).request("GET", "/v1/test", query: ["search": "USDC + café&order=1"])
        let requests = await mock.requests
        XCTAssertTrue(requests[0].url!.absoluteString.contains("USDC%20%2B%20caf%C3%A9%26order%3D1"))
    }
    func testPaginationAndSafety() async throws {
        func page(_ offset: Int, _ more: Bool, empty: Bool = false) throws -> WireResponse {
            try response(["data": empty ? [] : [["invoice_id": .string(fixtureID.uuidString), "status": "new", "amount": "25.00"]], "pagination": ["offset": .number(try JSONNumber(String(offset))), "limit": 1, "has_more": .bool(more)]])
        }
        let mock = MockTransport(responses: [try page(0, true), try page(1, false)])
        let client = WhollyCryptoClient(http: try testHTTP(mock))
        var count = 0
        for try await invoice in try client.invoices(projectID: fixtureID, pageSize: 1) { XCTAssertEqual(invoice.amount, "25.00"); count += 1 }
        XCTAssertEqual(count, 2)
        let broken = WhollyCryptoClient(http: try testHTTP(MockTransport(response: try page(0, true, empty: true))))
        var iterator = try broken.invoices(projectID: fixtureID, pageSize: 1).makeAsyncIterator()
        do { _ = try await iterator.next(); XCTFail("Empty page with has_more must fail") } catch is SDKError {}
    }
    func testOnboardingWithoutAuthorization() async throws {
        let mock = MockTransport(responses: [try response([:]), try response([:])])
        let client = OnboardingClient(http: try testHTTP(mock))
        _ = try await client.checkInvitation(token: "synthetic-invitation")
        _ = try await client.acceptInvitation(token: "synthetic-invitation", password: "synthetic-password-1234", custodyAcknowledged: true)
        let requests = await mock.requests
        XCTAssertEqual(requests.map { $0.url!.path }, ["/v1/onboarding/invitations/check", "/v1/onboarding/invitations/accept"])
        XCTAssertTrue(requests.allSatisfy { $0.value(forHTTPHeaderField: "Authorization") == nil })
        do { _ = try await client.acceptInvitation(token: "synthetic", password: "password", custodyAcknowledged: false); XCTFail() } catch is SDKError {}
    }
    func testOperatorMoneyAndKeyValidation() async throws {
        let mock = MockTransport(response: try response([:]))
        let client = OperatorClient(http: try testHTTP(mock))
        do { _ = try await client.adjustCredits(merchantID: fixtureID, body: ["amount": 25], idempotencyKey: "operator-test-key-1234"); XCTFail() } catch is SDKError {}
        do { _ = try await client.createMerchant(body: ["starting_credit": "10"], idempotencyKey: "short"); XCTFail() } catch is SDKError {}
        _ = try await client.adjustCredits(merchantID: fixtureID, body: ["amount": "-1.25"], idempotencyKey: "operator-test-key-1234")
    }
    func testCancellationBeforeRequest() async throws {
        let mock = MockTransport(response: try response([:]))
        let http = try testHTTP(mock)
        let task = Task { try await Task.sleep(nanoseconds: 1_000_000_000); return try await http.request("GET", "/") }
        task.cancel()
        do { _ = try await task.value; XCTFail() } catch is CancellationError {}
        let requests = await mock.requests; XCTAssertTrue(requests.isEmpty)
    }
    func testRedactedDescriptions() throws {
        let client = try WhollyCryptoClient(baseURL: "https://api.example.test", apiToken: fixtureToken)
        XCTAssertFalse(String(reflecting: client).contains(fixtureToken))
        XCTAssertFalse(String(describing: client).contains(fixtureToken))
    }
}
