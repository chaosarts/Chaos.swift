//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//
import Combine
import Foundation

public enum HttpRequestState: Hashable {
    case idle
    case pending
    case upload(Int64, total: Int64)
    case download(Int64, total: Int64)
    case complete

    public typealias Publisher = Subject<HttpRequestState, Never>
}
