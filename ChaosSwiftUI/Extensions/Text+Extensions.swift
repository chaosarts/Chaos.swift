//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

extension Text {
    public init<Value>(value: Value) where Value: CustomStringConvertible {
        self.init(value.description)
    }

    public init(format: String, arguments: [CVarArg]) {
        self.init(String(format: format, arguments: arguments))
    }

    public init(format: String, _ arguments: CVarArg...) {
        self.init(format: format, arguments: arguments)
    }
}
