import Foundation
import WhollyCrypto

// Trusted backend only. NEVER embed a payout key in a customer iOS app.
// Declaring these helpers never sends a request or authorizes a payout.
func marketplaceInvoice(client: MarketplaceClient, projectID: UUID, storeID: UUID,
                        vendorIDs: [UUID], savedKey: String) async throws -> APIResponse {
    precondition(vendorIDs.count == 3, "Use three approved vendors")
    return try await client.createInvoice(projectID: projectID, body: [
        "store_id": .string(storeID.uuidString.lowercased()), "amount": "300.00",
        "currency": "USD", "order_id": "marketplace-cart-1042",
        "allocations": .array(vendorIDs.map { ["vendor_id": .string($0.uuidString.lowercased()), "gross_amount": "100.00"] }),
    ], idempotencyKey: savedKey) // Persist key/body before sending; reuse after timeout.
    // Save data.invoice_id; return top-level links.checkout to the customer app.
}

// Before approval: use createPayout with available allocation_ids from one asset,
// maximum_network_fee_atomic and maximum_gas_funding_atomic as native atomic strings.
// Read getPayout; review recipients, amount, revision, plan_hash and caps.
// Only after explicit authorization, approvePayout with the reviewed revision,
// expected_plan_hash, confirm:true and a separately persisted approval retry key.
// Poll getPayout until state=paid. A broadcast is not a confirmation.
