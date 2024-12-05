//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

class TabBarSelection<Value>: ObservableObject {
    let value: Binding<Value>

    init(value: Binding<Value>) {
        self.value = value
    }
}

extension View {
    func tabBarSelection<Selection>(_ selection: Binding<Selection>) -> some View where Selection: Hashable {
        environmentObject(TabBarSelection(value: selection))
    }
}
