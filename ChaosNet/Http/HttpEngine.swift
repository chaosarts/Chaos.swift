//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public protocol HttpEngine: AnyObject {

    typealias DataResponse = (Data, HTTPURLResponse)

    typealias DownloadResponse = (URL, HTTPURLResponse)

    typealias UploadResponse = DataResponse

    var timeoutInterval: TimeInterval { get set }

    var cachePolicy: URLRequest.CachePolicy { get set }

    var shouldSetCookies: Bool { get set }

    var cookieStorage: HTTPCookieStorage? { get set }

    var additionalHeaders: [AnyHashable : Any]? { get set }

    func data(for request: URLRequest, publisher: (any HttpRequestState.Publisher)?) async throws -> DataResponse

    func download(for request: URLRequest, publisher: (any HttpRequestState.Publisher)?) async throws -> DownloadResponse

    func upload(for request: URLRequest, from data: Data, publisher: (any HttpRequestState.Publisher)?) async throws -> UploadResponse
}


extension HttpEngine {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try await data(for: request, publisher: nil)
    }

    func download(for request: URLRequest) async throws -> (URL, HTTPURLResponse) {
        try await download(for: request, publisher: nil)
    }

    func upload(for request: URLRequest, from data: Data) async throws -> (Data, HTTPURLResponse) {
        try await upload(for: request, from: data, publisher: nil)
    }
}
