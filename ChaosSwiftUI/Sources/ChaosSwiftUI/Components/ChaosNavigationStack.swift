//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public struct ChaosNavigationStack<Root>: View where Root: View {

    @ObservedObject var navigationState: NavigationState

    private let root: () -> Root

    public init(navigationState: NavigationState, @ViewBuilder root: @escaping () -> Root) {
        self.navigationState = navigationState
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: $navigationState.path, root: root)
            .environmentObject(navigationState)
    }
}
