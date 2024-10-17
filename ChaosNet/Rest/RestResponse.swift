//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public struct RestResponse<Data> {
    let data: Data
    let httpResponse: HTTPURLResponse

    init(_ data: Data, httpResponse: HTTPURLResponse) {
        self.data = data
        self.httpResponse = httpResponse
    }

    init(httpResponse: HTTPURLResponse) where Data == Void {
        self.data = Void()
        self.httpResponse = httpResponse
    }
}
