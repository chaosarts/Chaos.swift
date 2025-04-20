//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

public enum RestError: Error {
    case engineError(Error)
    case invalidDataResponse(HttpEngine.DataResponse)
}
