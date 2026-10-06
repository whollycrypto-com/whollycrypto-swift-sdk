// Generated route checks: synthetic transport only. No real requests.
import Foundation
import XCTest
@testable import WhollyCrypto

final class MarketplaceRoutesTests: XCTestCase {
    func test_capabilities() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "capabilities" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.capabilities(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/capabilities")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_overview() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "overview" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.overview(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/overview")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_settings() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "settings" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.settings(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/settings")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_saveSettings() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "saveSettings" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.saveSettings(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/settings")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_listVendors() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listVendors" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listVendors(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_createVendor() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "createVendor" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.createVendor(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_getVendor() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "getVendor" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.getVendor(projectID: fixtureID, vendorID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_updateVendor() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "updateVendor" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.updateVendor(projectID: fixtureID, vendorID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/update")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_archiveVendor() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "archiveVendor" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.archiveVendor(projectID: fixtureID, vendorID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/archive")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_listDestinations() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listDestinations" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listDestinations(projectID: fixtureID, vendorID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/destinations")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_addDestination() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "addDestination" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.addDestination(projectID: fixtureID, vendorID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/destinations")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_approveDestination() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "approveDestination" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.approveDestination(projectID: fixtureID, vendorID: fixtureID, destinationID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/destinations/11111111-1111-4111-8111-111111111111/approve")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_disableDestination() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "disableDestination" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.disableDestination(projectID: fixtureID, vendorID: fixtureID, destinationID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/destinations/11111111-1111-4111-8111-111111111111/disable")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_vendorBalances() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "vendorBalances" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.vendorBalances(projectID: fixtureID, vendorID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/vendors/11111111-1111-4111-8111-111111111111/balances")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_listInvoices() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listInvoices" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listInvoices(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_createInvoice() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "createInvoice" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.createInvoice(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_getInvoice() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "getInvoice" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.getInvoice(projectID: fixtureID, invoiceID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_invoicePayments() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "invoicePayments" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.invoicePayments(projectID: fixtureID, invoiceID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/payments")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_invoiceAllocations() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "invoiceAllocations" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.invoiceAllocations(projectID: fixtureID, invoiceID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/allocations")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_cancelInvoice() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "cancelInvoice" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.cancelInvoice(projectID: fixtureID, invoiceID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/cancel")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_holdInvoice() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "holdInvoice" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.holdInvoice(projectID: fixtureID, invoiceID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/allocations/hold")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_releaseInvoice() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "releaseInvoice" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.releaseInvoice(projectID: fixtureID, invoiceID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/allocations/release")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_rebindDestination() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "rebindDestination" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.rebindDestination(projectID: fixtureID, invoiceID: fixtureID, allocationID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/allocations/11111111-1111-4111-8111-111111111111/destination")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_refundInvoice() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "refundInvoice" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.refundInvoice(projectID: fixtureID, invoiceID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/invoices/11111111-1111-4111-8111-111111111111/refund")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_allocations() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "allocations" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.allocations(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/allocations")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_balances() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "balances" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.balances(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/balances")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_ledger() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "ledger" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.ledger(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/ledger")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_listPayouts() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listPayouts" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listPayouts(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_previewPayout() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "previewPayout" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.previewPayout(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts/preview")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_createPayout() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "createPayout" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.createPayout(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_getPayout() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "getPayout" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.getPayout(projectID: fixtureID, payoutID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts/11111111-1111-4111-8111-111111111111")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_approvePayout() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "approvePayout" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.approvePayout(projectID: fixtureID, payoutID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts/11111111-1111-4111-8111-111111111111/approve")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_resumePayout() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "resumePayout" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.resumePayout(projectID: fixtureID, payoutID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts/11111111-1111-4111-8111-111111111111/resume")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_cancelPayout() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "cancelPayout" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.cancelPayout(projectID: fixtureID, payoutID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/payouts/11111111-1111-4111-8111-111111111111/cancel")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_listPolicies() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listPolicies" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listPolicies(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/policies")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_savePolicy() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "savePolicy" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.savePolicy(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/policies")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_listWebhooks() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listWebhooks" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listWebhooks(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhooks")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_createWebhook() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "createWebhook" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.createWebhook(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhooks")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_updateWebhook() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "updateWebhook" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.updateWebhook(projectID: fixtureID, webhookID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhooks/11111111-1111-4111-8111-111111111111/update")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_disableWebhook() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "disableWebhook" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.disableWebhook(projectID: fixtureID, webhookID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhooks/11111111-1111-4111-8111-111111111111/disable")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_listEvents() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listEvents" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listEvents(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/events")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_getEvent() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "getEvent" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.getEvent(projectID: fixtureID, eventID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/events/11111111-1111-4111-8111-111111111111")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_listDeliveries() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "listDeliveries" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.listDeliveries(projectID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhook-deliveries")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_getDelivery() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "getDelivery" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        _ = try await client.getDelivery(projectID: fixtureID, deliveryID: fixtureID, query: ["page": "2"])
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhook-deliveries/11111111-1111-4111-8111-111111111111")
        let query = URLComponents(url: requests[0].url!, resolvingAgainstBaseURL: false)!.queryItems!
        XCTAssertEqual(query.first { $0.name == "project_id" }?.value, fixtureID.uuidString.lowercased())
        XCTAssertEqual(query.first { $0.name == "page" }?.value, "2")
    }
    func test_resendDelivery() async throws {
        let entry = try fixture("marketplace-v1")["methods"]!.arrayValue!.first { $0["name"]?.stringValue == "resendDelivery" }!
        let mock = MockTransport(response: try response(entry["response"]!))
        let client = MarketplaceClient(http: try testHTTP(mock))
        var body = entry["body"]!.objectValue!
        body["project_id"] = .string(fixtureID.uuidString.lowercased())
        _ = try await client.resendDelivery(projectID: fixtureID, deliveryID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/marketplace/webhook-deliveries/11111111-1111-4111-8111-111111111111/resend")
        XCTAssertEqual(requests[0].httpBody, try JSONValue.object(body).encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "marketplace-test-key-1234")
    }
    func test_validationBeforeTransport() async throws {
        XCTAssertThrowsError(try MarketplaceClient(baseURL: "https://api.example.test", apiToken: fixtureToken))
        let mock = MockTransport(response: try response([:]))
        let client = MarketplaceClient(http: try testHTTP(mock))
        let invalidBodies: [[String: JSONValue]] = [["amount": 1], ["allocations": [["gross_amount": 1]]], ["maximum_network_fee_atomic": 100]]
        for body in invalidBodies {
            do { _ = try await client.createInvoice(projectID: fixtureID, body: body, idempotencyKey: "marketplace-test-key-1234"); XCTFail() } catch is SDKError {}
        }
        do { _ = try await client.createVendor(projectID: fixtureID, body: [:], idempotencyKey: "short"); XCTFail() } catch is SDKError {}
        do { _ = try await client.listVendors(projectID: fixtureID, query: ["project_id": "wrong"]); XCTFail() } catch is SDKError {}
        let requests = await mock.requests
        XCTAssertTrue(requests.isEmpty)
        XCTAssertFalse(String(reflecting: client).contains(fixtureToken))
    }
}
