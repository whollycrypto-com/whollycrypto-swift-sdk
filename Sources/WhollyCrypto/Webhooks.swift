#if canImport(CryptoKit)
import Foundation
import CryptoKit

public struct Notification: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
    public let eventID: String
    public let deliveryID: String
    public let invoiceID: String
    public let eventType: String
    public let status: String
    public let sequence: String
    public let payload: JSONValue
    public var description: String { "WhollyCrypto.Notification()" }
    public var debugDescription: String { description }
}

/// Apple CryptoKit verifies raw HTTP bytes. Run callback receivers on your backend, not inside an iOS app.
public enum Webhooks {
    public static func verifySignature(rawBody: Data, signature: String, secret: String, now: Date = Date(), toleranceSeconds: Int = 300) throws -> Bool {
        guard !secret.isEmpty, secret.utf8.count <= 4096, (0...86400).contains(toleranceSeconds), now.timeIntervalSince1970.isFinite, now.timeIntervalSince1970 >= 0 else { throw SDKError.validation("Invalid signing secret, clock or tolerance.") }
        guard rawBody.count <= 262_144, signature.range(of: #"\At=(?:0|[1-9][0-9]{0,11}),v1=[a-f0-9]{64}\z"#, options: .regularExpression) != nil else { return false }
        let parts = signature.split(separator: ",")
        let timestamp = String(parts[0].dropFirst(2))
        guard let seconds = TimeInterval(timestamp), abs(floor(now.timeIntervalSince1970) - seconds) <= Double(toleranceSeconds) else { return false }
        let hex = Array(parts[1].dropFirst(3))
        let mac = Data(stride(from: 0, to: hex.count, by: 2).map { UInt8(String(hex[$0...($0 + 1)]), radix: 16)! })
        var signed = Data((timestamp + ".").utf8); signed.append(rawBody)
        return HMAC<SHA256>.isValidAuthenticationCode(mac, authenticating: signed, using: SymmetricKey(data: Data(secret.utf8)))
    }

    /// Pass all raw header pairs so duplicate security headers can be rejected.
    public static func parseNotification(rawBody: Data, headers: [(String, String)], secret: String, now: Date = Date(), toleranceSeconds: Int = 300) throws -> Notification {
        guard headers.count <= 128 else { throw SDKError.invalidSignature }
        var normalized: [String: String] = [:]
        for (name, value) in headers where ["wholly-signature", "wholly-event-id", "wholly-delivery-id"].contains(name.lowercased()) {
            let key = name.lowercased()
            guard normalized[key] == nil else { throw SDKError.invalidSignature }
            normalized[key] = value
        }
        guard let signature = normalized["wholly-signature"],
              try verifySignature(rawBody: rawBody, signature: signature, secret: secret, now: now, toleranceSeconds: toleranceSeconds),
              let event = normalized["wholly-event-id"].flatMap(UUID.init(uuidString:)),
              let delivery = normalized["wholly-delivery-id"].flatMap(UUID.init(uuidString:)),
              let json = try? JSONValue.parse(rawBody, maximumBytes: 262_144), json["payload_version"]?.intValue == 2,
              let invoice = json["invoice_id"]?.stringValue.flatMap(UUID.init(uuidString:)),
              json["event_id"]?.stringValue.flatMap(UUID.init(uuidString:)) == event,
              json["project_id"]?.stringValue.flatMap(UUID.init(uuidString:)) != nil,
              json["store_id"]?.stringValue.flatMap(UUID.init(uuidString:)) != nil,
              let status = json["status"]?.stringValue, ["new", "processing", "settled", "expired", "invalid", "cancelled"].contains(status),
              let type = json["event_type"]?.stringValue, ["invoice.created", "payment.received", "invoice.processing", "invoice.settled", "invoice.expired", "invoice.invalid", "invoice.cancelled"].contains(type),
              let sequence = json["sequence"]?.numberString ?? json["sequence"]?.stringValue,
              sequence.range(of: #"\A[1-9][0-9]{0,18}\z"#, options: .regularExpression) != nil,
              let n = Int64(sequence), n > 0 else { throw SDKError.invalidSignature }
        return Notification(eventID: event.uuidString.lowercased(), deliveryID: delivery.uuidString.lowercased(), invoiceID: invoice.uuidString.lowercased(), eventType: type, status: status, sequence: sequence, payload: json)
    }
}
#endif
