//
//  ViewExample.swift
//  ChaosSwiftUIExample
//
//  Created by Fu Lam Diep on 08.10.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ChaosCore

public class ViewExample: Identifiable {

    public let id: String

    public let view: AnyView

    public init<V: View> (id: String? = nil, view: V) {
        self.id = id ?? Self.id(fromType: V.self)
        self.view = AnyView(view)
    }

    private static func id<V: View> (fromType type: V.Type) -> String {
        try! String(describing: type)
            .replacing(pattern: "ViewExample$")
            .replacing(pattern: "([a-z])([A-Z])", withString: "$1 $2")
    }
}
