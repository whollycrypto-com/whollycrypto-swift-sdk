import UIKit
import SafariServices

/// Customer-facing app example. No merchant API key belongs in this app.
/// Your own authenticated backend validates the cart/price, persists the invoice
/// idempotency key, calls Wholly Crypto and returns {"checkout_url":"https://pay..."}.
@MainActor
final class CheckoutViewController: UIViewController {
    private struct Checkout: Decodable { let checkout_url: URL }
    private var checkoutTask: Task<Void, Never>?

    func openCheckout(orderID: String, customerSession: String) {
        checkoutTask?.cancel()
        checkoutTask = Task { [weak self] in
            do {
                var request = URLRequest(url: URL(string: "https://shop.example.com/mobile/checkout")!)
                request.httpMethod = "POST"
                // This is your SHOP's customer session, never a Wholly Crypto API token.
                request.setValue("Bearer " + customerSession, forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONEncoder().encode(["order_id": orderID])
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw URLError(.badServerResponse) }
                let checkout = try JSONDecoder().decode(Checkout.self, from: data)
                // Replace with your active checkout host(s); never open an arbitrary returned URL.
                guard checkout.checkout_url.scheme == "https", checkout.checkout_url.host == "pay.example.com",
                      checkout.checkout_url.user == nil, checkout.checkout_url.password == nil else { throw URLError(.badURL) }
                self?.present(SFSafariViewController(url: checkout.checkout_url), animated: true)
                // Your backend handles signed IPN/webhooks. Returning to this app is NOT payment proof.
            } catch is CancellationError {
                // The backend may have created an invoice; reuse the same order on retry.
            } catch {
                let alert = UIAlertController(title: "Checkout unavailable", message: "Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
}
