import Foundation
import WhollyCrypto

// Compile-only example unless you explicitly supply server-side credentials and UUIDs.
// Persist/reuse WHOLLY_IDEMPOTENCY_KEY with the exact payload before running.
let env = ProcessInfo.processInfo.environment
guard let origin = env["WHOLLY_API_URL"], let token = env["WHOLLY_API_TOKEN"],
      let projectID = env["WHOLLY_PROJECT_ID"].flatMap(UUID.init(uuidString:)),
      let storeID = env["WHOLLY_STORE_ID"].flatMap(UUID.init(uuidString:)),
      let key = env["WHOLLY_IDEMPOTENCY_KEY"] else {
    print("Configure the documented server environment before running. No request was sent.")
    exit(0)
}
do {
    let client = try WhollyCryptoClient(baseURL: origin, apiToken: token)
    var invoice = InvoiceCreateRequest(amount: "25.00", currency: "EUR")
    invoice.orderID = "swift-example-1042"
    let result = try await client.createInvoice(projectID: projectID, storeID: storeID, invoice: invoice, idempotencyKey: key)
    print(result.invoice?.invoiceID ?? "Invoice identifier missing")
    print(result.checkoutURL?.absoluteString ?? "Checkout link missing")
} catch let error as APIError {
    print(error.description) // Safe summary only, no customer data or credentials.
    exit(1)
} catch {
    print("Request failed. Check privately and reuse the same key before retrying.")
    exit(1)
}
