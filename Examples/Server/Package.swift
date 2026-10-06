// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "WhollyServerExample",
    platforms: [.macOS(.v12)],
    dependencies: [.package(name: "WhollyCrypto", path: "../..")],
    targets: [.executableTarget(name: "WhollyServerExample", dependencies: [.product(name: "WhollyCrypto", package: "WhollyCrypto")])]
)
