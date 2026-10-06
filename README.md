# Wholly Crypto Swift SDK

[![MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Use your own [Wholly Crypto](https://www.whollycrypto.com/) installation from Swift.
An async/await client for **Xcode, iOS 15+ and macOS 12+**, with Swift 5.9+ and no
third-party dependencies. Includes merchant, Operator and invitation clients.

**Source preview:** public API contract checks pass, but Swift compilation and
Apple-platform tests have not run yet. There is no tagged stable release.
Build and test in Xcode before using this preview; do not assume production readiness.


## Marketplace · merchant 8.0.0+

Use the separate `MarketplaceClient` and a project-scoped `wc_marketplace_...` key
for vendors, split invoices, protected balances, payout plans and signed events.
BTC and supported EVM assets only. Keep spending keys on a trusted backend, never
in customer JavaScript or a shipped mobile app. Writes require a saved retry key;
preparing a payout does not authorize sending it.

[Setup and safety](docs/marketplace-api.md) · [Invoice and payout example](Examples/Marketplace.swift) ·
[Signed event receiver](Examples/MarketplaceWebhook.swift) · [All endpoints](https://www.whollycrypto.com/api/#marketplace)
## Install in Xcode

Choose **File → Add Package Dependencies**, paste this repository URL and select
**Branch**, using **main** while this source preview is being verified. Add the **WhollyCrypto**
product to your target:

```text
https://github.com/whollycrypto-com/whollycrypto-swift-sdk.git
```

Or add it to a Swift package:

```swift
.package(url: "https://github.com/whollycrypto-com/whollycrypto-swift-sdk.git", branch: "main")
// In your target's dependencies:
.product(name: "WhollyCrypto", package: "whollycrypto-swift-sdk")
```

For a manual local install, download the main branch source archive and add its folder
as a local Swift package in Xcode. Keep the whole package, not selected source files.
No CocoaPods or registry account is needed. Once a stable version is verified and
tagged, use its version requirement instead of tracking the main branch.

## Choose the right app architecture

**A customer-facing iOS app must not contain a merchant or Operator API key.**
Have your own authenticated backend create the invoice, then return its checkout
URL to the app. Open it in Safari or `SFSafariViewController`. A success redirect
is not proof of payment; your backend verifies signed notifications and settlement.
See the [complete UIKit example](Examples/iOSCheckout.swift).

A merchant-owned management app can accept an individually provisioned,
project-restricted API credential at runtime and store it in Keychain. Do not
hard-code credentials, put them in Info.plist or ship a shared secret in an App
Store binary. Keychain does not hide credentials from the device's owner. Use
read-only access if the app only displays invoices or balances. Keep Operator
administration and webhook signing secrets on trusted servers.

## Create an invoice

This example runs in a trusted service or merchant-owned management tool, **not a
public shopping app**. The API origin is your installation's API domain, not its
merchant or checkout URL. Copy UUIDs from **Project → Stores → Basic → API IDs**.

```swift
import Foundation
import WhollyCrypto

let client = try WhollyCryptoClient(
    baseURL: "https://api.example.com",
    apiToken: apiTokenFromSecureConfiguration
)
var invoice = InvoiceCreateRequest(amount: "25.00", currency: "EUR")
invoice.orderID = "order-1042"
invoice.email = "customer@example.com"
invoice.description = "Your order"
invoice.metadata = ["cart_id": "cart-1042"]
invoice.paymentMethods = [
    .init(chainSlug: "ethereum", assetTickers: ["ETH", "USDC", "USDT"]),
    .init(chainSlug: "solana") // All active assets accepted by this store on Solana.
]

// Generate once, save with the unchanged payload BEFORE sending, reuse on retries.
let key = WhollyCryptoClient.newIdempotencyKey()
let result = try await client.createInvoice(
    projectID: projectUUID, storeID: storeUUID,
    invoice: invoice, idempotencyKey: key
)
let invoiceID = result.invoice?.invoiceID
let checkoutURL = result.checkoutURL
```

Amounts, percentages and fiat/token values are **decimal strings**, never `Double`.
Use a string from validated user input or an exact decimal source, not
`String(0.1 + 0.2)`. `JSONValue` preserves large numbers and unknown response fields.
Response access: `result.json["data"]?["invoice_id"]?.stringValue`.
`invoice_id` is the same public UUID used in checkout and notifications.

Omit `paymentMethods` to use the store defaults. A chain without tickers includes
all its active accepted assets; unaccepted choices are ignored and, if none
match, the API falls back to store defaults. `[]` is invalid. The SDK cannot
override store permissions. For Lightning use `paymentRail: "lightning"` with
`chainSlug: "bitcoin"`; native BTC and Lightning are different payment rails.

All ten checkout languages are accepted as strings: `en`, `de`, `es`, `pt-BR`,
`it`, `ru`, `zh-CN`, `fr`, `ko`, `ja`. Optional `checkoutAppearance` and
`additionalFields` support documented appearance and new public API fields.

## Read invoices and handle errors

```swift
for try await invoice in try client.invoices(
    projectID: projectUUID, filters: ["status": "settled"], pageSize: 50
) {
    // Store intentional fields only. Do not log customer payloads by default.
    print(invoice.invoiceID)
}

do {
    let result = try await client.getInvoice(projectID: projectUUID, invoiceID: invoiceUUID)
    // Read result.invoice?.status, amount, currency, orderID or result.json.
    _ = result
} catch let error as APIError {
    print(error.statusCode, error.code) // Safe summary, not the full body.
    let retryAfter = error.retryAfterSeconds
    let issues = error.paymentMethodIssues // Opt-in private diagnostics for your admin UI.
    _ = (retryAfter, issues, error.apiMessage, error.details)
} catch is CancellationError {
    // A cancelled write may still have succeeded. Reuse its original key and payload.
}
```

Use `listInvoices(..., filters: ["limit": "25", "offset": "0"])` for explicit
pages. The lazy `invoices` sequence checks pagination progress and stops safely
on malformed responses. Callers own retry scheduling; **no request retries
automatically**, including writes. Honor `Retry-After` for rate limits. Never
create a new idempotency key merely because a request timed out.

TLS validation stays enabled. Redirects, persistent cookies and stored HTTP
credentials are disabled. Timeout defaults to 30 seconds; response bodies are
capped at 4 MiB while streaming. Configure with `ClientConfiguration`. Only tests
can opt into HTTP on a literal loopback host. Cancelling a Swift task cancels its
network request. Concurrent calls carry their own response metadata.

## What is included

| Client | Public API coverage |
| --- | --- |
| `WhollyCryptoClient` | 18 routes: invoices/payments, asset policies, token candidates/custom tokens, store asset selection, wallets, reconciliation and health |
| `OperatorClient` | 55 scoped routes: merchants/users/invitations, stores/projects, local credits/top-ups, credentials, reports and webhooks |
| `OnboardingClient` | Check and accept an invitation using its token only |
| `Webhooks` | Apple CryptoKit verification of raw IPN/invoice webhook signatures and version-2 notifications |

See [Operator examples](docs/operator-api.md), [IPN/webhooks](Examples/ipn-webhooks.md)
and the [server package example](Examples/Server). Operator endpoints require
Wholly Crypto 7.4.0+ in Operator mode, with a separate credential. The current
public contract was checked against merchant 7.8.1. No wallet keys, fund-sending
API, server implementation or private-service API is included.

`updateStorePaymentAssets` replaces the complete on-chain selection. An empty
array clears it. Read and merge the existing selection before changing it;
Lightning configuration is separate. The merchant API does not list/create
projects and stores; the separately authorized Operator API does.

## IPN and webhooks

Receive them on your backend. Verify `Wholly-Signature` against the **exact raw
HTTP body**, before parsing. IPN uses the store IPN secret; each configured
webhook endpoint has its own secret. They are not API tokens.

`status` is an invoice snapshot; `event_type` explains why it was sent. On a fast
chain, both `payment.received` and `invoice.settled` can contain `status: settled`.
For normal fulfillment, handle `invoice.settled`, check `status == "settled"`,
validate your expected invoice/order/amount/currency and fulfill **once per
invoice**. Durably deduplicate `event_id`. Multiple events can share `sequence`;
do not drop a settlement just because another event had the same sequence.

Read the [notification example](Examples/ipn-webhooks.md) and
[full API event reference](https://www.whollycrypto.com/api/#notification-events).
[`Examples/notification.json`](Examples/notification.json) is synthetic data.

## Build and contribute

```sh
swift test
swift build -c release
```

The test suite is prepared for macOS and iOS Simulator, with a Swift 5.9 networking
core check on Linux. Automated builds are not enabled in this repository yet.
CryptoKit callback verification is only exported on Apple platforms. Linux is
not a replacement for the iOS tests. Tests use synthetic data, not live payments.
See [maintenance](docs/maintaining.md), [security](SECURITY.md) and [changelog](CHANGELOG.md).

[Website](https://www.whollycrypto.com/) · [API reference](https://www.whollycrypto.com/api/)
· [SDKs](https://www.whollycrypto.com/sdks/) · [Issues](https://github.com/whollycrypto-com/whollycrypto-swift-sdk/issues)

MIT license applies to this client SDK, not to the Wholly Crypto server.
