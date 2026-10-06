# SDK maintenance

This is an intentionally public API client, not the merchant server. Keep server
implementation, private services, wallet data and credentials out of this repo.

The package uses Swift 5.9 language features, iOS 15+ / macOS 12+, and no external
dependencies. CryptoKit notification verification is Apple-only. The intended
Linux check covers the Foundation networking core on Swift 5.9, not CryptoKit.
The initial source preview has not been compiled or tested in Swift yet.

For public API changes, update methods, examples and the synthetic fixtures in
`Tests/WhollyCryptoTests/Fixtures` together. Fixtures are extracted from the public
merchant API reference, never implementation. Then run:

```sh
node tools/generate-operator.mjs --check
node tools/check-api-coverage.mjs /path/to/api-docs.js /path/to/api-examples.js
swift test
swift build -c release
```

Before a stable release, build and test the package on an iOS simulator, type-check
the UIKit checkout example, and build a separate Swift Package consumer. GitHub
Actions is not currently enabled for this source preview. Tests must never
create real invoices, send payments or call live customer installations.

All monetary request values are strings. JSONValue preserves number lexemes and
stable key order; keep precision, duplicate-key, raw signature, redirect, timeout,
response-limit, cancellation, pagination and exact-route tests when refactoring.
Never automatically retry writes or expose secrets through debug descriptions.

Before an SDK release, review only the SDK tree, run all CI gates, update its
independent semantic version in the User-Agent and changelog, tag the exact green
commit, then create an immutable GitHub release. Verify a clean SPM consumer
resolves the published tag. Xcode uses Git tags; there is no separate registry
upload. A merchant release and website deployment are separate actions.
