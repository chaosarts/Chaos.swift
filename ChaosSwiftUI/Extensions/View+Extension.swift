//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftUI

extension View {
    public func apply(@ViewBuilder modifier: (Self) -> some View) -> some View {
        modifier(self)
    }

    public func tintStyle(_ style: some ShapeStyle) -> some View {
        tint(style)
    }
}
