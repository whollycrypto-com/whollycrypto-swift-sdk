// Generated public route coverage: inert fixtures only.
import Foundation
import XCTest
@testable import WhollyCrypto

final class OperatorRoutesTests: XCTestCase {
    func test_capabilities() async throws {
        let entry = try operatorFixture("capabilities")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.capabilities()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/capabilities")
    }
    func test_health() async throws {
        let entry = try operatorFixture("health")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.health()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/health")
    }
    func test_listMerchants() async throws {
        let entry = try operatorFixture("listMerchants")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listMerchants()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants")
    }
    func test_createMerchant() async throws {
        let entry = try operatorFixture("createMerchant")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createMerchant(body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getMerchant() async throws {
        let entry = try operatorFixture("getMerchant")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getMerchant(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111")
    }
    func test_updateMerchant() async throws {
        let entry = try operatorFixture("updateMerchant")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateMerchant(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listUsers() async throws {
        let entry = try operatorFixture("listUsers")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listUsers(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/users")
    }
    func test_createUser() async throws {
        let entry = try operatorFixture("createUser")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createUser(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/users")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getUser() async throws {
        let entry = try operatorFixture("getUser")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getUser(merchantID: fixtureID, userID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/users/11111111-1111-4111-8111-111111111111")
    }
    func test_updateUser() async throws {
        let entry = try operatorFixture("updateUser")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateUser(merchantID: fixtureID, userID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/users/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_setUserPassword() async throws {
        let entry = try operatorFixture("setUserPassword")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.setUserPassword(merchantID: fixtureID, userID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/users/11111111-1111-4111-8111-111111111111/password")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_revokeUserSessions() async throws {
        let entry = try operatorFixture("revokeUserSessions")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.revokeUserSessions(merchantID: fixtureID, userID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/users/11111111-1111-4111-8111-111111111111/revoke-sessions")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listInvitations() async throws {
        let entry = try operatorFixture("listInvitations")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listInvitations(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/invitations")
    }
    func test_createInvitation() async throws {
        let entry = try operatorFixture("createInvitation")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createInvitation(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/invitations")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getInvitation() async throws {
        let entry = try operatorFixture("getInvitation")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getInvitation(invitationID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/invitations/11111111-1111-4111-8111-111111111111")
    }
    func test_resendInvitation() async throws {
        let entry = try operatorFixture("resendInvitation")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.resendInvitation(invitationID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/invitations/11111111-1111-4111-8111-111111111111/resend")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_revokeInvitation() async throws {
        let entry = try operatorFixture("revokeInvitation")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.revokeInvitation(invitationID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/invitations/11111111-1111-4111-8111-111111111111/revoke")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getCredits() async throws {
        let entry = try operatorFixture("getCredits")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getCredits(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/credits")
    }
    func test_listCreditLedger() async throws {
        let entry = try operatorFixture("listCreditLedger")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listCreditLedger(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/credits/ledger")
    }
    func test_adjustCredits() async throws {
        let entry = try operatorFixture("adjustCredits")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.adjustCredits(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/credits/adjustments")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listTopups() async throws {
        let entry = try operatorFixture("listTopups")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listTopups(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/topups")
    }
    func test_createTopup() async throws {
        let entry = try operatorFixture("createTopup")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createTopup(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/topups")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getTopup() async throws {
        let entry = try operatorFixture("getTopup")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getTopup(merchantID: fixtureID, topupID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/topups/11111111-1111-4111-8111-111111111111")
    }
    func test_reports() async throws {
        let entry = try operatorFixture("reports")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.reports()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/reports")
    }
    func test_listAudit() async throws {
        let entry = try operatorFixture("listAudit")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listAudit()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/audit")
    }
    func test_listEvents() async throws {
        let entry = try operatorFixture("listEvents")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listEvents()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/events")
    }
    func test_listWebhooks() async throws {
        let entry = try operatorFixture("listWebhooks")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listWebhooks()
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/webhooks")
    }
    func test_createWebhook() async throws {
        let entry = try operatorFixture("createWebhook")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createWebhook(body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/webhooks")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_updateWebhook() async throws {
        let entry = try operatorFixture("updateWebhook")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateWebhook(webhookID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/webhooks/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_rotateWebhookSecret() async throws {
        let entry = try operatorFixture("rotateWebhookSecret")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.rotateWebhookSecret(webhookID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/webhooks/11111111-1111-4111-8111-111111111111/rotate")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listWebhookDeliveries() async throws {
        let entry = try operatorFixture("listWebhookDeliveries")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listWebhookDeliveries(webhookID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/webhooks/11111111-1111-4111-8111-111111111111/deliveries")
    }
    func test_listProjects() async throws {
        let entry = try operatorFixture("listProjects")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listProjects(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects")
    }
    func test_createProject() async throws {
        let entry = try operatorFixture("createProject")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createProject(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getProject() async throws {
        let entry = try operatorFixture("getProject")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getProject(merchantID: fixtureID, projectID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111")
    }
    func test_updateProject() async throws {
        let entry = try operatorFixture("updateProject")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateProject(merchantID: fixtureID, projectID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listStores() async throws {
        let entry = try operatorFixture("listStores")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listStores(merchantID: fixtureID, projectID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores")
    }
    func test_createStore() async throws {
        let entry = try operatorFixture("createStore")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createStore(merchantID: fixtureID, projectID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getStore() async throws {
        let entry = try operatorFixture("getStore")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getStore(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111")
    }
    func test_updateStore() async throws {
        let entry = try operatorFixture("updateStore")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateStore(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_getStoreAppearance() async throws {
        let entry = try operatorFixture("getStoreAppearance")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getStoreAppearance(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/checkout-appearance")
    }
    func test_updateStoreAppearance() async throws {
        let entry = try operatorFixture("updateStoreAppearance")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateStoreAppearance(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/checkout-appearance")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listStorePaymentAssets() async throws {
        let entry = try operatorFixture("listStorePaymentAssets")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listStorePaymentAssets(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/payment-assets")
    }
    func test_updateStorePaymentAssets() async throws {
        let entry = try operatorFixture("updateStorePaymentAssets")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateStorePaymentAssets(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/payment-assets")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listStoreWebhooks() async throws {
        let entry = try operatorFixture("listStoreWebhooks")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listStoreWebhooks(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/webhooks")
    }
    func test_createStoreWebhook() async throws {
        let entry = try operatorFixture("createStoreWebhook")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createStoreWebhook(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/webhooks")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_updateStoreWebhook() async throws {
        let entry = try operatorFixture("updateStoreWebhook")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateStoreWebhook(merchantID: fixtureID, projectID: fixtureID, storeID: fixtureID, webhookID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/stores/11111111-1111-4111-8111-111111111111/webhooks/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_listInvoices() async throws {
        let entry = try operatorFixture("listInvoices")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listInvoices(merchantID: fixtureID, projectID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/invoices")
    }
    func test_getInvoice() async throws {
        let entry = try operatorFixture("getInvoice")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.getInvoice(merchantID: fixtureID, projectID: fixtureID, invoiceID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/invoices/11111111-1111-4111-8111-111111111111")
    }
    func test_listWallets() async throws {
        let entry = try operatorFixture("listWallets")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listWallets(merchantID: fixtureID, projectID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/wallets")
    }
    func test_listWalletAddresses() async throws {
        let entry = try operatorFixture("listWalletAddresses")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listWalletAddresses(merchantID: fixtureID, projectID: fixtureID, walletID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/projects/11111111-1111-4111-8111-111111111111/wallets/11111111-1111-4111-8111-111111111111/addresses")
    }
    func test_listMerchantCredentials() async throws {
        let entry = try operatorFixture("listMerchantCredentials")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.listMerchantCredentials(merchantID: fixtureID)
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "GET")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/api-credentials")
    }
    func test_createMerchantCredential() async throws {
        let entry = try operatorFixture("createMerchantCredential")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.createMerchantCredential(merchantID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/api-credentials")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_updateMerchantCredential() async throws {
        let entry = try operatorFixture("updateMerchantCredential")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.updateMerchantCredential(merchantID: fixtureID, credentialID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/api-credentials/11111111-1111-4111-8111-111111111111")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_rotateMerchantCredential() async throws {
        let entry = try operatorFixture("rotateMerchantCredential")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.rotateMerchantCredential(merchantID: fixtureID, credentialID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/api-credentials/11111111-1111-4111-8111-111111111111/rotate")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
    func test_revokeMerchantCredential() async throws {
        let entry = try operatorFixture("revokeMerchantCredential")
        let mock = MockTransport(response: WireResponse(status: 200, headers: ["content-type": "application/json"], body: try entry["response"]!.encoded()))
        let client = OperatorClient(http: try testHTTP(mock))
        _ = try await client.revokeMerchantCredential(merchantID: fixtureID, credentialID: fixtureID, body: entry["body"]!.objectValue!, idempotencyKey: "operator-test-key-1234")
        let requests = await mock.requests
        XCTAssertEqual(requests.count, 1)
        XCTAssertEqual(requests[0].httpMethod, "POST")
        XCTAssertEqual(requests[0].url?.path, "/v1/operator/merchants/11111111-1111-4111-8111-111111111111/api-credentials/11111111-1111-4111-8111-111111111111/revoke")
        XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded())
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Idempotency-Key"), "operator-test-key-1234")
    }
}
