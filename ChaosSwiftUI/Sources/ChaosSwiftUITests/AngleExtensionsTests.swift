//
//  Copyright © 2024 Chrono24 GmbH. All rights reserved.
//

import XCTest
import SwiftUI
@testable import ChaosSwiftUI
import Foundation

class AngleExtensionsTests: XCTestCase {

    func test_normalize() {
        XCTAssertEqual(Angle(degrees: 761).normalized().degrees, 41, accuracy: 0.000000001)
        XCTAssertEqual(Angle(degrees: -761).normalized().degrees, 319, accuracy: 0.000000001)
    }

    func test_MinimalDistance() {
        let angle: Angle = .degrees(390)
        XCTAssertEqual(angle.normalizedDistance(to: .degrees(450), clockwise: true).degrees, Angle.degrees(60).degrees, accuracy: 0.000000000001)
        XCTAssertEqual(angle.normalizedDistance(to: .degrees(450), clockwise: false).degrees, Angle.degrees(300).degrees, accuracy: 0.000000000001)
        XCTAssertEqual(angle.normalizedDistance(to: .degrees(270), clockwise: true).degrees, Angle.degrees(240).degrees, accuracy: 0.000000000001)
        XCTAssertEqual(angle.normalizedDistance(to: .degrees(270), clockwise: false).degrees, Angle.degrees(120).degrees, accuracy: 0.000000000001)
        XCTAssertEqual(angle.normalizedDistance(to: .degrees(10), clockwise: true).degrees, Angle.degrees(340).degrees, accuracy: 0.000000000001)
        XCTAssertEqual(angle.normalizedDistance(to: .degrees(10), clockwise: false).degrees, Angle.degrees(20).degrees, accuracy: 0.00000000001)
    }
}
