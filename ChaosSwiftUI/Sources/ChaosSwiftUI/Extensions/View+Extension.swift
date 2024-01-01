//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftUI

extension View {
    func sizeThatFits(_ size: CGSize) -> CGSize {
        UIHostingController(rootView: self).view.sizeThatFits(size)
    }
}
