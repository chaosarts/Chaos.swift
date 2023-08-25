//
//  EdgeInsets+Init.swift
//  Chrono24
//
//  Created by Fu Lam Diep on 30.04.22.
//

import Foundation
import SwiftUI

public extension EdgeInsets {

    static let zero: EdgeInsets = EdgeInsets(0)

    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    init(_ value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
}
