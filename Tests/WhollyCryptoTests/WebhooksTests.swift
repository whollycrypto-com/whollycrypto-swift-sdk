#if canImport(CryptoKit)
import Foundation
import CryptoKit
import XCTest
@testable import WhollyCrypto

final class WebhooksTests: XCTestCase {
    let now = Date(timeIntervalSince1970: 1_700_000_000)
    let secret = "synthetic-signing-secret"
    func signed(_ raw: Data, timestamp: String = "1700000000") -> String {
        var bytes = Data((timestamp + ".").utf8); bytes.append(raw)
        let signature = HMAC<SHA256>.authenticationCode(for: bytes, using: SymmetricKey(data: Data(secret.utf8))).map { String(format: "%02x", $0) }.joined()
        return "t=\(timestamp),v1=\(signature)"
    }
    func payload() throws -> Data {
        try JSONValue.object(["payload_version": 2, "event_id": .string(fixtureID.uuidString), "invoice_id": .string(fixtureID.uuidString), "project_id": .string(fixtureID.uuidString), "store_id": .string(fixtureID.uuidString), "sequence": 3, "status": "settled", "event_type": "payment.received"]).encoded()
    }
    func testRawSignatureAndTimestamp() throws {
        let raw = try payload()
        XCTAssertTrue(try Webhooks.verifySignature(rawBody: raw, signature: signed(raw), secret: secret, now: now))
        XCTAssertFalse(try Webhooks.verifySignature(rawBody: raw + Data(" ".utf8), signature: signed(raw), secret: secret, now: now))
        XCTAssertFalse(try Webhooks.verifySignature(rawBody: raw, signature: signed(raw), secret: "wrong", now: now))
        XCTAssertFalse(try Webhooks.verifySignature(rawBody: raw, signature: signed(raw, timestamp: "1699999699"), secret: secret, now: now))
        XCTAssertFalse(try Webhooks.verifySignature(rawBody: raw, signature: signed(raw, timestamp: "1700000301"), secret: secret, now: now))
        XCTAssertFalse(try Webhooks.verifySignature(rawBody: raw, signature: signed(raw) + ",v1=bad", secret: secret, now: now))
    }
    func testParseAndRejectDuplicateHeaders() throws {
        let raw = try payload()
        let headers = [("Wholly-Signature", signed(raw)), ("Wholly-Event-Id", fixtureID.uuidString), ("Wholly-Delivery-Id", fixtureID.uuidString)]
        let event = try Webhooks.parseNotification(rawBody: raw, headers: headers, secret: secret, now: now)
        XCTAssertEqual(event.status, "settled"); XCTAssertEqual(event.eventType, "payment.received")
        XCTAssertEqual(event.sequence, "3")
        XCTAssertThrowsError(try Webhooks.parseNotification(rawBody: raw, headers: headers + [("wholly-event-id", fixtureID.uuidString)], secret: secret, now: now))
        let changed = [("Wholly-Signature", signed(raw)), ("Wholly-Event-Id", UUID().uuidString), ("Wholly-Delivery-Id", fixtureID.uuidString)]
        XCTAssertThrowsError(try Webhooks.parseNotification(rawBody: raw, headers: changed, secret: secret, now: now))
    }
}
#endif
