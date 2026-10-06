#if canImport(CryptoKit)
import Foundation
import WhollyCrypto

// Trusted backend with CryptoKit, not a receiver running in a customer app.
func verifiedMarketplaceEvent(rawBody: Data, signature: String, secret: String,
                              expectedProjects: Set<UUID>) throws -> JSONValue {
    guard try Webhooks.verifySignature(rawBody: rawBody, signature: signature, secret: secret) else {
        throw SDKError.invalidSignature
    }
    let event = try JSONValue.parse(rawBody)
    let types = ["marketplace.invoice.created", "marketplace.allocations.available", "marketplace.allocations.held",
                 "marketplace.payout.approved", "marketplace.payout.broadcast", "marketplace.payout.confirmed",
                 "marketplace.payout.partial", "marketplace.payout.failed", "marketplace.payout.cancelled",
                 "marketplace.refund.prepared", "marketplace.refund.confirmed"]
    guard event["payload_version"]?.intValue == 1,
          event["event_id"]?.stringValue.flatMap(UUID.init(uuidString:)) != nil,
          let project = event["project_id"]?.stringValue.flatMap(UUID.init(uuidString:)), expectedProjects.contains(project),
          let type = event["event_type"]?.stringValue, types.contains(type), event["data"]?.objectValue != nil else {
        throw SDKError.invalidSignature
    }
    return event
}
// Save the authenticated event_id uniquely and queue work durably before 2xx.
// Duplicate deliveries never authorize a second transfer. Reconcile current
// retained payout state; do not use the invoice notification parser for this body.
#endif
