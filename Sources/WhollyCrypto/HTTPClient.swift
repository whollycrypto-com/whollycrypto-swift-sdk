import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct ClientConfiguration: Sendable {
    public var timeout: TimeInterval = 30
    public var maximumResponseBytes = 4_194_304
    /// Tests only. Still refuses every non-loopback HTTP host.
    public var allowInsecureLocalhost = false
    public init() {}
}

struct WireResponse: Sendable {
    let status: Int
    let headers: [String: String]
    let body: Data
}
protocol HTTPTransport: Sendable {
    func send(_ request: URLRequest, configuration: ClientConfiguration) async throws -> WireResponse
}

struct HTTPClient: Sendable {
    private let origin: URL
    private let token: String?
    private let configuration: ClientConfiguration
    private let transport: any HTTPTransport

    init(baseURL: String, token: String?, configuration: ClientConfiguration, transport: any HTTPTransport = URLSessionTransport()) throws {
        guard configuration.timeout.isFinite, configuration.timeout > 0, configuration.timeout <= 120,
              (1024...67_108_864).contains(configuration.maximumResponseBytes) else { throw SDKError.validation("Invalid timeout or response limit.") }
        guard !baseURL.contains(where: { $0.isWhitespace || $0 == "\\" }),
              let parts = URLComponents(string: baseURL), let url = parts.url,
              let host = parts.host, !host.isEmpty, parts.user == nil, parts.password == nil,
              parts.query == nil, parts.fragment == nil, parts.path == "" || parts.path == "/",
              parts.port == nil || (1...65535).contains(parts.port!),
              parts.scheme == "https" || (configuration.allowInsecureLocalhost && parts.scheme == "http" && ["localhost", "127.0.0.1", "[::1]", "::1"].contains(host)) else {
            throw SDKError.validation("Use an HTTPS API origin with no credentials, /v1 path, query or fragment.")
        }
        if let token {
            guard !token.isEmpty, token.utf8.count <= 4096, token.utf8.allSatisfy({ (33...126).contains($0) }) else { throw SDKError.validation("API token must be nonempty visible ASCII without whitespace.") }
        }
        self.origin = url; self.token = token; self.configuration = configuration; self.transport = transport
    }

    func request(_ method: String, _ path: String, query: [String: String] = [:], body: JSONValue? = nil, idempotencyKey: String? = nil, authenticated: Bool = true) async throws -> APIResponse {
        try Task.checkCancellation()
        guard path.range(of: #"\A/[a-zA-Z0-9/_-]*\z"#, options: .regularExpression) != nil, !path.hasPrefix("//") else { throw SDKError.validation("Invalid API path.") }
        var components = URLComponents(url: origin, resolvingAgainstBaseURL: false)!
        components.path = path
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        for key in query.keys {
            guard key.range(of: #"\A[a-z_]+\z"#, options: .regularExpression) != nil else { throw SDKError.validation("Invalid query parameter name.") }
        }
        if !query.isEmpty { components.percentEncodedQuery = query.keys.sorted().map { $0 + "=" + query[$0]!.addingPercentEncoding(withAllowedCharacters: allowed)! }.joined(separator: "&") }
        guard let url = components.url else { throw SDKError.validation("Invalid request URL.") }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: configuration.timeout)
        request.httpMethod = method
        request.httpShouldHandleCookies = false
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("WhollyCrypto-Swift/1.0.0", forHTTPHeaderField: "User-Agent")
        if authenticated {
            guard let token else { throw SDKError.validation("This operation requires an API token.") }
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        if let idempotencyKey {
            guard (1...128).contains(idempotencyKey.utf8.count), idempotencyKey.utf8.allSatisfy({ (33...126).contains($0) }) else { throw SDKError.validation("Idempotency key must be 1–128 visible ASCII characters without spaces.") }
            request.setValue(idempotencyKey, forHTTPHeaderField: "Idempotency-Key")
        }
        if let body {
            guard body.objectValue != nil else { throw SDKError.validation("Request body must be a JSON object.") }
            request.httpBody = try body.encoded()
            guard request.httpBody!.count <= 1_048_576 else { throw SDKError.validation("Request exceeds 1 MiB.") }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        // No automatic retries, including writes. Retrying invoice creation requires the SAME key and payload.
        let wire = try await transport.send(request, configuration: configuration)
        guard wire.body.count <= configuration.maximumResponseBytes else { throw SDKError.responseTooLarge }
        if (300..<400).contains(wire.status) { throw SDKError.redirectRefused }
        let type = wire.headers["content-type"]?.split(separator: ";").first?.trimmingCharacters(in: .whitespaces).lowercased() ?? ""
        let isJSON = type == "application/json" || (type.hasPrefix("application/") && type.hasSuffix("+json"))
        let json = isJSON ? try? JSONValue.parse(wire.body, maximumBytes: configuration.maximumResponseBytes) : nil
        // Redact an echoed API token from explicit error diagnostics too.
        var safeBody = wire.body
        var safeJSON = json ?? .object([:])
        var safeHeaders = wire.headers
        if !(200..<300).contains(wire.status), let token {
            safeBody = Data(String(decoding: safeBody, as: UTF8.self).replacingOccurrences(of: token, with: "[redacted]").utf8)
            safeJSON = (try? JSONValue.parse(safeBody)) ?? .object([:])
            safeHeaders = safeHeaders.mapValues { $0.replacingOccurrences(of: token, with: "[redacted]") }
        }
        let response = APIResponse(json: safeJSON, statusCode: wire.status, headers: safeHeaders, rawBody: safeBody)
        guard (200..<300).contains(wire.status) else { throw APIError(response: response) }
        guard json?.objectValue != nil else { throw SDKError.invalidResponse("Expected a JSON object response from the API.") }
        return response
    }
}

struct URLSessionTransport: HTTPTransport {
    func send(_ request: URLRequest, configuration: ClientConfiguration) async throws -> WireResponse {
        let operation = NetworkOperation(request: request, configuration: configuration)
        return try await withTaskCancellationHandler(operation: {
            try await withCheckedThrowingContinuation { operation.start($0) }
        }, onCancel: { operation.finish(.failure(CancellationError())) })
    }
}

// All mutable state is protected by lock; URLSession owns the delegate until invalidated.
private final class NetworkOperation: NSObject, URLSessionDataDelegate, @unchecked Sendable {
    private let lock = NSLock()
    private let request: URLRequest
    private let configuration: ClientConfiguration
    private var continuation: CheckedContinuation<WireResponse, Error>?
    private var completed: Result<WireResponse, Error>?
    private var session: URLSession?
    private var response: HTTPURLResponse?
    private var data = Data()
    init(request: URLRequest, configuration: ClientConfiguration) { self.request = request; self.configuration = configuration }
    func start(_ continuation: CheckedContinuation<WireResponse, Error>) {
        lock.lock()
        if let completed { lock.unlock(); continuation.resume(with: completed); return }
        self.continuation = continuation
        let config = URLSessionConfiguration.ephemeral
        config.httpShouldSetCookies = false; config.httpCookieStorage = nil
        config.urlCredentialStorage = nil; config.urlCache = nil
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = configuration.timeout
        config.timeoutIntervalForResource = configuration.timeout
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        self.session = session
        let task = session.dataTask(with: request)
        lock.unlock()
        task.resume()
    }
    func finish(_ result: Result<WireResponse, Error>) {
        lock.lock()
        guard completed == nil else { lock.unlock(); return }
        completed = result
        let continuation = self.continuation; self.continuation = nil
        let session = self.session; self.session = nil
        lock.unlock()
        session?.invalidateAndCancel()
        continuation?.resume(with: result)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
        finish(.failure(SDKError.redirectRefused))
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Never supply Basic/NTLM/client credentials. Keep normal platform TLS trust verification.
        if challenge.protectionSpace.authenticationMethod == "NSURLAuthenticationMethodServerTrust" { completionHandler(.performDefaultHandling, nil) }
        else { completionHandler(.cancelAuthenticationChallenge, nil) }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse else { completionHandler(.cancel); finish(.failure(SDKError.invalidResponse("Expected HTTP response."))); return }
        let headersSize = response.allHeaderFields.reduce(0) { $0 + String(describing: $1.key).utf8.count + String(describing: $1.value).utf8.count }
        guard response.expectedContentLength <= configuration.maximumResponseBytes, headersSize <= 32_768 else {
            completionHandler(.cancel); finish(.failure(SDKError.responseTooLarge)); return
        }
        lock.lock(); self.response = response; lock.unlock()
        completionHandler(.allow)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        lock.lock()
        let exceeds = self.data.count + data.count > configuration.maximumResponseBytes
        if !exceeds { self.data.append(data) }
        lock.unlock()
        if exceeds { finish(.failure(SDKError.responseTooLarge)) }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        lock.lock(); let response = self.response; let body = data; lock.unlock()
        guard error == nil, let response else { finish(.failure(SDKError.transport)); return }
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields { headers[String(describing: key).lowercased()] = String(describing: value) }
        finish(.success(WireResponse(status: response.statusCode, headers: headers, body: body)))
    }
}
