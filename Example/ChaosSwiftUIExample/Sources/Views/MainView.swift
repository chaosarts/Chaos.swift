//
//  ContentView.swift
//  ChaosSwiftUIExample
//
//  Created by Fu Lam Diep on 08.10.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ChaosSwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MoleculeRootView()
        }
        .accentColor(Color("Primary Accent Color"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
