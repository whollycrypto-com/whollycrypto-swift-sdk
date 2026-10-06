// Generated from the reviewed public Marketplace contract.
import Foundation
extension MarketplaceClient {
    /// GET /v1/marketplace/capabilities; marketplace.read.
    public func capabilities(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/capabilities", query: query)
    }
    /// GET /v1/marketplace/overview; marketplace.read.
    public func overview(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/overview", query: query)
    }
    /// GET /v1/marketplace/settings; marketplace.read.
    public func settings(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/settings", query: query)
    }
    /// POST /v1/marketplace/settings; policies.write.
    public func saveSettings(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/settings", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/vendors; marketplace.read.
    public func listVendors(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/vendors", query: query)
    }
    /// POST /v1/marketplace/vendors; vendors.write.
    public func createVendor(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/vendors", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/vendors/{vendor_id}; marketplace.read.
    public func getVendor(projectID: UUID, vendorID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())", query: query)
    }
    /// POST /v1/marketplace/vendors/{vendor_id}/update; vendors.write.
    public func updateVendor(projectID: UUID, vendorID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/update", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/vendors/{vendor_id}/archive; vendors.write.
    public func archiveVendor(projectID: UUID, vendorID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/archive", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/vendors/{vendor_id}/destinations; marketplace.read.
    public func listDestinations(projectID: UUID, vendorID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/destinations", query: query)
    }
    /// POST /v1/marketplace/vendors/{vendor_id}/destinations; destinations.write.
    public func addDestination(projectID: UUID, vendorID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/destinations", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/vendors/{vendor_id}/destinations/{destination_id}/approve; destinations.approve.
    public func approveDestination(projectID: UUID, vendorID: UUID, destinationID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/destinations/\(destinationID.uuidString.lowercased())/approve", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/vendors/{vendor_id}/destinations/{destination_id}/disable; destinations.approve.
    public func disableDestination(projectID: UUID, vendorID: UUID, destinationID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/destinations/\(destinationID.uuidString.lowercased())/disable", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/vendors/{vendor_id}/balances; marketplace.read.
    public func vendorBalances(projectID: UUID, vendorID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/vendors/\(vendorID.uuidString.lowercased())/balances", query: query)
    }
    /// GET /v1/marketplace/invoices; marketplace.read.
    public func listInvoices(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/invoices", query: query)
    }
    /// POST /v1/marketplace/invoices; invoices.write.
    public func createInvoice(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/invoices", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/invoices/{invoice_id}; marketplace.read.
    public func getInvoice(projectID: UUID, invoiceID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())", query: query)
    }
    /// GET /v1/marketplace/invoices/{invoice_id}/payments; marketplace.read.
    public func invoicePayments(projectID: UUID, invoiceID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/payments", query: query)
    }
    /// GET /v1/marketplace/invoices/{invoice_id}/allocations; marketplace.read.
    public func invoiceAllocations(projectID: UUID, invoiceID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/allocations", query: query)
    }
    /// POST /v1/marketplace/invoices/{invoice_id}/cancel; invoices.write.
    public func cancelInvoice(projectID: UUID, invoiceID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/cancel", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/invoices/{invoice_id}/allocations/hold; reconciliation.write.
    public func holdInvoice(projectID: UUID, invoiceID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/allocations/hold", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/invoices/{invoice_id}/allocations/release; reconciliation.write.
    public func releaseInvoice(projectID: UUID, invoiceID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/allocations/release", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/invoices/{invoice_id}/allocations/{allocation_id}/destination; reconciliation.write.
    public func rebindDestination(projectID: UUID, invoiceID: UUID, allocationID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/allocations/\(allocationID.uuidString.lowercased())/destination", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/invoices/{invoice_id}/refund; reconciliation.write.
    public func refundInvoice(projectID: UUID, invoiceID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/invoices/\(invoiceID.uuidString.lowercased())/refund", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/allocations; marketplace.read.
    public func allocations(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/allocations", query: query)
    }
    /// GET /v1/marketplace/balances; marketplace.read.
    public func balances(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/balances", query: query)
    }
    /// GET /v1/marketplace/ledger; marketplace.read.
    public func ledger(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/ledger", query: query)
    }
    /// GET /v1/marketplace/payouts; marketplace.read.
    public func listPayouts(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/payouts", query: query)
    }
    /// POST /v1/marketplace/payouts/preview; payouts.write.
    public func previewPayout(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/payouts/preview", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/payouts; payouts.write.
    public func createPayout(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/payouts", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/payouts/{payout_id}; marketplace.read.
    public func getPayout(projectID: UUID, payoutID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/payouts/\(payoutID.uuidString.lowercased())", query: query)
    }
    /// POST /v1/marketplace/payouts/{payout_id}/approve; payouts.approve.
    public func approvePayout(projectID: UUID, payoutID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/payouts/\(payoutID.uuidString.lowercased())/approve", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/payouts/{payout_id}/resume; payouts.approve.
    public func resumePayout(projectID: UUID, payoutID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/payouts/\(payoutID.uuidString.lowercased())/resume", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/payouts/{payout_id}/cancel; payouts.write.
    public func cancelPayout(projectID: UUID, payoutID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/payouts/\(payoutID.uuidString.lowercased())/cancel", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/policies; marketplace.read.
    public func listPolicies(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/policies", query: query)
    }
    /// POST /v1/marketplace/policies; policies.write.
    public func savePolicy(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/policies", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/webhooks; marketplace.read.
    public func listWebhooks(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/webhooks", query: query)
    }
    /// POST /v1/marketplace/webhooks; webhooks.write.
    public func createWebhook(projectID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/webhooks", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/webhooks/{webhook_id}/update; webhooks.write.
    public func updateWebhook(projectID: UUID, webhookID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/webhooks/\(webhookID.uuidString.lowercased())/update", body: body, idempotencyKey: idempotencyKey)
    }
    /// POST /v1/marketplace/webhooks/{webhook_id}/disable; webhooks.write.
    public func disableWebhook(projectID: UUID, webhookID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/webhooks/\(webhookID.uuidString.lowercased())/disable", body: body, idempotencyKey: idempotencyKey)
    }
    /// GET /v1/marketplace/events; marketplace.read.
    public func listEvents(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/events", query: query)
    }
    /// GET /v1/marketplace/events/{event_id}; marketplace.read.
    public func getEvent(projectID: UUID, eventID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/events/\(eventID.uuidString.lowercased())", query: query)
    }
    /// GET /v1/marketplace/webhook-deliveries; marketplace.read.
    public func listDeliveries(projectID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/webhook-deliveries", query: query)
    }
    /// GET /v1/marketplace/webhook-deliveries/{delivery_id}; marketplace.read.
    public func getDelivery(projectID: UUID, deliveryID: UUID, query: [String: String] = [:]) async throws -> APIResponse {
        try await read(projectID, "/v1/marketplace/webhook-deliveries/\(deliveryID.uuidString.lowercased())", query: query)
    }
    /// POST /v1/marketplace/webhook-deliveries/{delivery_id}/resend; webhooks.write.
    public func resendDelivery(projectID: UUID, deliveryID: UUID, body: [String: JSONValue], idempotencyKey: String) async throws -> APIResponse {
        try await write(projectID, "/v1/marketplace/webhook-deliveries/\(deliveryID.uuidString.lowercased())/resend", body: body, idempotencyKey: idempotencyKey)
    }
}
