//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import XCTest
@testable import ChaosSwiftUI

class NavigationStateTests: XCTestCase {
    func test_popToItem() {
        let navigationState = NavigationState()
        navigationState.push(NavigationItem.details)
        navigationState.push(NavigationItem.edit)
        navigationState.push(NavigationItem.details)
        navigationState.push(NavigationItem.results, bookmark: true)
        navigationState.push(NavigationItem.edit)
        navigationState.push(NavigationItem.details)
        navigationState.push(NavigationItem.overview)

        navigationState.popTo(item: NavigationItem.edit)
        XCTAssertEqual(navigationState.count, 7)

        navigationState.popTo(item: NavigationItem.results)
        XCTAssertEqual(navigationState.count, 4)
    }

    enum NavigationItem: Hashable {
        case details
        case results
        case overview
        case edit
    }
}
