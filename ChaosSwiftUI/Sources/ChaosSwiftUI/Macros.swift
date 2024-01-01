//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftUI

@attached(peer, names: arbitrary)
@attached(accessor, names: named(get), named(set))
public macro EnvironmentValue() = #externalMacro(module: "ChaosSwiftUIMacros", type: "EnvironmentValueMacro")

extension EnvironmentValues {
    @EnvironmentValue
    public var cardColor: Color = Color.white
}
