# Security

Never post API tokens, wallet secrets, customer data or signing secrets to an issue.
Report suspected security vulnerabilities privately through
[Wholly Crypto contact](https://www.whollycrypto.com/contact/), without including
secrets. Include the SDK version and a minimal synthetic reproducer.

Use HTTPS, project-restricted credentials and read-only access when sufficient.
Do not embed shared merchant/Operator credentials in distributed apps. Verify
raw notification signatures server-side and make fulfillment idempotent.

The SDK disables redirects and persistent cookies, enforces time/size limits and
does not automatically retry requests. Cancellation or a transport error does not
prove an invoice/write was not accepted. Reuse the original idempotency key and
exact payload. Explicit response fields may include personal data; logging them
is the caller's decision, never the default.
