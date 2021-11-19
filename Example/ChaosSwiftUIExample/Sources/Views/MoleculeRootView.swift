//
//  MoleculeRootView.swift
//  ChaosSwiftUIExample
//
//  Created by Fu Lam Diep on 08.10.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

public struct MoleculeRootView: View {

    private let examples: [ViewExample] = [
        ViewExample(view: PieChartViewExample())
    ]

    public var body: some View {
        NavigationView {
            List(examples, id: \.id) { element in
                NavigationLink(element.id, destination: element.view)
            }
            .navigationTitle("Molecules")
        }
        .tabItem { Label("Molecules", image: "Molecule") }
    }
}

public struct MoleculeRootView_Preview: PreviewProvider {
    public static var previews: some View {
        MoleculeRootView()
    }
}
