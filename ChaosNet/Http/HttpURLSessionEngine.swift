//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import ChaosCore
import Foundation

public class HttpURLSessionEngine: NSObject, HttpEngine {

    private var logger: Log = Log(HttpURLSessionEngine.self)

    private var urlSession: URLSession

    public var configuration: URLSessionConfiguration {
        urlSession.configuration
    }

    public var timeoutInterval: TimeInterval {
        get { configuration.timeoutIntervalForRequest }
        set { configuration.timeoutIntervalForRequest = newValue }
    }

    public var cachePolicy: URLRequest.CachePolicy {
        get { configuration.requestCachePolicy }
        set { configuration.requestCachePolicy = newValue }
    }

    public var shouldSetCookies: Bool {
        get { configuration.httpShouldSetCookies }
        set { configuration.httpShouldSetCookies = newValue }
    }

    public var cookieStorage: HTTPCookieStorage? {
        get { configuration.httpCookieStorage }
        set { configuration.httpCookieStorage = newValue }
    }

    public var additionalHeaders: [AnyHashable : Any]? {
        get { configuration.httpAdditionalHeaders }
        set { configuration.httpAdditionalHeaders = newValue }
    }

    private var publishers: [Int : any HttpRequestState.Publisher] = [:]

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public convenience init(configuration: URLSessionConfiguration) {
        self.init(urlSession: URLSession(configuration: configuration))
    }

    public func data(for request: URLRequest, publisher: (any HttpRequestState.Publisher)?) async throws -> DataResponse {
        try await registerRequest(request: request, publisher: publisher) {
            try await urlSession.data(for: request, delegate: self)
        }
    }

    public func download(for request: URLRequest, publisher: (any HttpRequestState.Publisher)?) async throws -> DownloadResponse {
        try await registerRequest(request: request, publisher: publisher) {
            try await urlSession.download(for: request, delegate: self)
        }
    }

    public func upload(for request: URLRequest, from data: Data, publisher: (any HttpRequestState.Publisher)?) async throws -> UploadResponse {
        try await registerRequest(request: request, publisher: publisher) {
            try await urlSession.upload(for: request, from: data, delegate: self)
        }
    }

    private func registerRequest<Output>(request: URLRequest, publisher: (any HttpRequestState.Publisher)?, action: () async throws -> (Output, URLResponse)) async throws -> (Output, HTTPURLResponse)
    where Output: CustomDebugStringConvertible {
        if let publisher {
            publishers[request.hashValue] = publisher
            publisher.send(.pending)
        }

        defer {
            if let publisher {
                publishers[request.hashValue] = nil
                publisher.send(.complete)
            }
        }

        logger.info(format: "Sending request: \n@%", request.debugDescription)
        let (output, response) = try await action()
        guard let response = response as? HTTPURLResponse else {
            logger.error(format: "Non HTTPURLResponse received: @%", response.debugDescription)
            throw URLError(.cannotParseResponse)
        }
        logger.info(format: "Server Response:\nHTTP: @%\nOutput: %@", response.debugDescription, output.debugDescription)
        return (output, response)
    }
}

extension HttpURLSessionEngine {
    public static let shared: HttpURLSessionEngine = HttpURLSessionEngine()
}

extension HttpURLSessionEngine: URLSessionTaskDelegate {

}

extension HttpURLSessionEngine: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let request = task.originalRequest else {
            return
        }
        publishers[request.hashValue]?.send(.upload(totalBytesSent, total: totalBytesExpectedToSend))
    }
}

extension HttpURLSessionEngine: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let request = downloadTask.originalRequest else {
            return
        }
        publishers[request.hashValue]?.send(.download(totalBytesWritten, total: totalBytesExpectedToWrite))
    }
}


extension HttpEngine where Self == HttpURLSessionEngine {
    public static var urlSession: HttpURLSessionEngine {
        .shared
    }
}
