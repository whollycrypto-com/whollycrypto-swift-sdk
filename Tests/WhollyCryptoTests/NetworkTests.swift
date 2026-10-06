import Foundation
import XCTest
@testable import WhollyCrypto

final class NetworkTests: XCTestCase {
    func localHTTP(timeout: Double = 3, limit: Int = 4096) throws -> HTTPClient {
        guard let origin = ProcessInfo.processInfo.environment["WHOLLY_TEST_ORIGIN"] else { throw XCTSkip("Start tools/test-server.py and set WHOLLY_TEST_ORIGIN for loopback-only network tests.") }
        var config = ClientConfiguration(); config.allowInsecureLocalhost = true; config.timeout = timeout; config.maximumResponseBytes = limit
        return try HTTPClient(baseURL: origin, token: fixtureToken, configuration: config)
    }
    func testRealTransportAndNoCookies() async throws {
        let http = try localHTTP()
        _ = try await http.request("GET", "/cookie")
        let result = try await http.request("GET", "/")
        XCTAssertEqual(result.json["cookie"], .null)
        XCTAssertEqual(result.json["authorization"], .string("Bearer " + fixtureToken))
    }
    func testRejectRedirect() async throws {
        let http = try localHTTP()
        do { _ = try await http.request("GET", "/redirect"); XCTFail("Redirect must be refused") }
        catch SDKError.redirectRefused {}
        let count = try await http.request("GET", "/redirect-count")
        XCTAssertEqual(count.json["count"]?.intValue, 0)
    }
    func testResponseSizeBothKnownAndStreaming() async throws {
        let http = try localHTTP(limit: 1024)
        for path in ["/large", "/stream"] {
            do { _ = try await http.request("GET", path); XCTFail("Response must be bounded") }
            catch SDKError.responseTooLarge {}
        }
    }
    func testTimeout() async throws {
        let http = try localHTTP(timeout: 0.1)
        do { _ = try await http.request("GET", "/slow"); XCTFail() } catch SDKError.transport {}
    }
    func testInFlightCancellation() async throws {
        let http = try localHTTP()
        let task = Task { try await http.request("GET", "/slow") }
        try await Task.sleep(nanoseconds: 50_000_000)
        task.cancel()
        do { _ = try await task.value; XCTFail() } catch is CancellationError {}
    }
    func testInvalidJSONAndHTMLSuccess() async throws {
        let http = try localHTTP()
        for path in ["/malformed", "/html"] {
            do { _ = try await http.request("GET", path); XCTFail() } catch SDKError.invalidResponse {}
        }
    }
}
