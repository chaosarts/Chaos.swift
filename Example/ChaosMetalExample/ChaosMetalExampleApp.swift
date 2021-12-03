//
//  ChaosMetalExampleApp.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ChaosCore
import ChaosMetal

@main
struct ChaosMetalExampleApp: App {
    var body: some Scene {
        WindowGroup {
            let size = NSScreen.main?.frame.size ?? CGSize(width: 1200, height: 800)
            ContentView(image: NSImage(named: "ExampleImage"))
                .frame(maxWidth: size.width, maxHeight: size.height, alignment: .center)
        }
    }

    init() {
        Log.enable(.all, forType: ChaosMetal.Environment.self)
    }
}
