//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public struct SizeClass {
    public let horizontal: UserInterfaceSizeClass
    public let vertical: UserInterfaceSizeClass
}

extension EnvironmentValues {
    public var sizeClass: SizeClass? {
        guard let horizontalSizeClass, let verticalSizeClass else {
            return nil
        }
        return SizeClass(horizontal: horizontalSizeClass, vertical: verticalSizeClass)
    }
}
