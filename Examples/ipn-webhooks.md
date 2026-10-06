# IPN and webhook receiver (Swift / macOS)

Use this in a trusted server handler with Apple CryptoKit, not an iOS HTTP listener.
The SDK does not start a server. Pass original bytes and all raw header pairs from
your HTTP framework. Reject duplicate security headers before a framework joins
or discards them. Default timestamp tolerance is 300 seconds; keep the server clock synced.

```swift
import Foundation
import WhollyCrypto

let event = try Webhooks.parseNotification(
    rawBody: originalHTTPBodyData,
    headers: rawHTTPHeaderPairs,
    secret: signingSecretFromSecureStorage
)
// Verify your expected invoice_id, project/store, order_id, currency and invoice amount.
// Persist event.eventID in an inbox with a UNIQUE constraint. Return 2xx only after
// durable acceptance; return non-2xx if the inbox cannot be saved.
// Process asynchronously. Repeated delivery of an accepted event should get 2xx.
if event.eventType == "invoice.settled" && event.status == "settled" {
    // In ONE database transaction: check the known invoice/order values and
    // record fulfillment uniquely by invoiceID. Never fulfill a second time.
}
```

`Wholly-Signature` is `t=TIMESTAMP,v1=HEX_HMAC_SHA256`. It signs timestamp + `.` +
raw body using the literal UTF-8 signing secret. Do not re-encode JSON or hex-decode
the secret. IPN uses the store IPN secret; each webhook uses its endpoint secret.

`invoice.created`, `invoice.processing`, `invoice.settled`, `invoice.expired`,
`invoice.invalid`, `invoice.cancelled` and `payment.received` are event types.
Invoice status snapshots are `new`, `processing`, `settled`, `expired`, `invalid`,
`cancelled`. Event type and status are different: `payment.received` can already
carry a settled snapshot. Several events may have the same sequence. Deduplicate
by event ID, not by sequence alone; fulfillment must be unique per invoice too.

Amounts remain strings. `paid_chain`, `paid_asset`, `paid_asset_amount`,
`paid_asset_amount_received`, `settlement_exchange_rate` and `payment_info` provide
settlement/payment detail, but are not a reason to bypass signature verification
or trusted order checks. Some settlement fields are null before settlement.
Do not sum different assets; embedded observations can be truncated. Fetch
`listInvoicePayments` for the complete current observations. Never trust a
checkout success redirect as payment proof.

[Public API and event reference](https://www.whollycrypto.com/api/#notification-events)
· [Delivery and retry guidance](https://www.whollycrypto.com/documentation/#delivery-history)
· [Synthetic payload](notification.json).

Operator lifecycle webhooks are a different payload schema. On Apple platforms,
`Webhooks.verifySignature` verifies their raw signature; validate their documented
Operator event schema separately. Do not pass them to the invoice-only
`parseNotification` helper. Swift on Linux needs an independently verified
HMAC-SHA256 implementation such as Swift Crypto; this package deliberately has
no external crypto dependency and does not export the helper there.
