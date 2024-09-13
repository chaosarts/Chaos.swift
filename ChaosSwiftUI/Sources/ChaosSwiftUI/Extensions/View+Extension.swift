//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftUI

extension View {
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        UIHostingController(rootView: self).view.sizeThatFits(size)
    }

    public func apply(@ViewBuilder modifier: (Self) -> some View) -> some View {
        modifier(self)
    }
}
