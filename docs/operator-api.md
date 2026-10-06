# Operator API

For a trusted administrative backend connected to an Operator-mode installation
(Wholly Crypto 7.4.0+). Create a separate scoped Operator credential under the
Operator panel's API access. It is not a merchant token and must not ship in a
customer app. API origin and permissions come from your installation; use
capabilities to check access. No private-service API is included.

```swift
import Foundation
import WhollyCrypto

let client = try OperatorClient(baseURL: "https://api.example.com", apiToken: operatorToken)
let capabilities = try await client.capabilities()
let merchants = try await client.listMerchants(query: ["page": "1", "page_size": "25"])

// Save this key with the exact intended request before the first attempt.
let key = WhollyCryptoClient.newIdempotencyKey()
let created = try await client.createMerchant(body: [
    "name": "Example shop",
    "email": "owner@example.com",
    "onboarding": "invitation",
    "currency": "EUR",
    "starting_credit": "0"
], idempotencyKey: key)
```

Every write requires an explicit 16–128 character key and JSON object. UUID path
parameters are typed `UUID`; bodies use `JSONValue`, amounts are decimal strings.
Preserve the same key and payload if a write response is lost. No automatic retries.
Read `APIError.apiMessage`, `details` and `retryAfterSeconds` privately as needed.

All 55 named methods are in [OperatorRoutes.swift](../Sources/WhollyCrypto/OperatorRoutes.swift):
merchant/direct onboarding, users, invitations, credits/ledger, top-ups,
projects/stores/appearance/assets/webhooks, invoices, wallets/addresses, API
credentials, reports/audit/events and webhook management. Full replacement of
accepted assets has the same destructive-selection semantics as the merchant API.
Secret-returning responses are intentionally not logged by their description.

## Invitation acceptance

```swift
let onboarding = try OnboardingClient(baseURL: "https://api.example.com")
let info = try await onboarding.checkInvitation(token: tokenFromInvitation)
// Show the operator-custody disclosure. Let the person choose their password and
// explicitly acknowledge it. Do not hard-code consent in an unattended job.
let accepted = try await onboarding.acceptInvitation(
    token: tokenFromInvitation, password: passwordChosenByUser,
    custodyAcknowledged: userCheckedCustodyDisclosure
)
```

This client sends no Authorization header. Invitation tokens are secrets. Do not
log links, tokens, passwords, response bodies or newly created credentials.
Acceptance is not automatically retried. If its response is lost, check sign-in
or invitation state instead of attempting repeated acceptance blindly.

[Public Operator API reference](https://www.whollycrypto.com/api/#operator-api)
includes scopes, request fields and response examples. The SDK does not grant
additional permissions, and it does not log a user into the merchant console.
