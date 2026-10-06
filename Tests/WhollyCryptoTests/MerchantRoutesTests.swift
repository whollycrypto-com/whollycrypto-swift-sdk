import Foundation
import XCTest
@testable import WhollyCrypto

final class MerchantRoutesTests: XCTestCase {
    func testAll18MerchantRoutes() async throws {
        let entries = try fixture("api-v1")["endpoints"]!.arrayValue!
        XCTAssertEqual(entries.count, 18)
        for entry in entries {
            let mock = MockTransport(response: try response(entry["response"]!))
            let client = WhollyCryptoClient(http: try testHTTP(mock))
            let body = entry["body"]?.objectValue ?? [:]
            let id = entry["id"]!.stringValue!
            switch id {
            case "api-service-root": _ = try await client.serviceInfo()
            case "api-health": _ = try await client.health()
            case "list-project-payment-assets": _ = try await client.listProjectPaymentAssets(projectID: fixtureID)
            case "update-project-payment-asset": _ = try await client.updateProjectPaymentAsset(projectID: fixtureID, assetID: fixtureID, policy: body)
            case "list-token-candidates": _ = try await client.listTokenCandidates(projectID: fixtureID, chainSlug: "ethereum")
            case "register-token-asset": _ = try await client.registerTokenAsset(projectID: fixtureID, token: body)
            case "discover-custom-dex-pools": _ = try await client.discoverCustomDexPools(projectID: fixtureID, chainSlug: "ethereum", contractAddress: "synthetic-contract")
            case "register-custom-token": _ = try await client.registerCustomToken(projectID: fixtureID, token: body)
            case "list-store-payment-assets": _ = try await client.listStorePaymentAssets(projectID: fixtureID, storeID: fixtureID)
            case "update-store-payment-assets": _ = try await client.updateStorePaymentAssets(projectID: fixtureID, storeID: fixtureID, assets: body["assets"]!.arrayValue!.map { $0.objectValue! })
            case "update-store-confirmation-policy": _ = try await client.updateStoreConfirmationPolicy(projectID: fixtureID, storeID: fixtureID, assetID: fixtureID, policy: body)
            case "list-project-wallets": _ = try await client.listProjectWallets(projectID: fixtureID)
            case "create-invoice":
                var invoice = InvoiceCreateRequest(amount: "49.90", currency: "USD")
                invoice.paymentMethods = [.init(chainSlug: "bitcoin", assetTickers: ["BTC"])]
                invoice.orderID = body["order_id"]?.stringValue; invoice.email = body["email"]?.stringValue
                invoice.description = body["description"]?.stringValue; invoice.ipnURL = body["ipn_url"]?.stringValue
                invoice.redirectURL = body["redirect_url"]?.stringValue; invoice.cancelURL = body["cancel_url"]?.stringValue
                invoice.language = body["language"]?.stringValue; invoice.metadata = body["metadata"]?.objectValue
                invoice.checkoutAppearance = body["checkout_appearance"]?.objectValue
                invoice.exchangeRateSpreadPercent = body["exchange_rate_spread_percent"]?.stringValue
                invoice.underpaymentTolerancePercent = body["underpayment_tolerance_percent"]?.stringValue
                invoice.additionalFields["redirect_automatically"] = body["redirect_automatically"]
                _ = try await client.createInvoice(projectID: fixtureID, storeID: fixtureID, invoice: invoice, idempotencyKey: "invoice-fixture-key")
            case "list-invoices": _ = try await client.listInvoices(projectID: fixtureID)
            case "get-invoice": _ = try await client.getInvoice(projectID: fixtureID, invoiceID: fixtureID)
            case "list-invoice-payments": _ = try await client.listInvoicePayments(projectID: fixtureID, invoiceID: fixtureID)
            case "reconciliation-list": _ = try await client.listReconciliation(projectID: fixtureID)
            case "reconciliation-detail": _ = try await client.getReconciliation(projectID: fixtureID, invoiceID: fixtureID)
            default: XCTFail("Uncovered public route: \(id)")
            }
            let requests = await mock.requests
            XCTAssertEqual(requests.count, 1, id)
            let path = entry["path"]!.stringValue!.replacingOccurrences(of: #"\{[a-z_]+\}"#, with: fixtureID.uuidString.lowercased(), options: .regularExpression)
            XCTAssertEqual(requests[0].url?.path, path, id)
            XCTAssertEqual(requests[0].httpMethod, entry["method"]?.stringValue, id)
            if entry["body"] != .null { XCTAssertEqual(requests[0].httpBody, try entry["body"]!.encoded(), id) }
        }
    }
}
