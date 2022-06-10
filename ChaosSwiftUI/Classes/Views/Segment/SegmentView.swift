//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 15.05.22.
//

import SwiftUI

public struct SegmentView<Content: View>: View {

    public init(@ViewBuilder _ content: () -> Content) {
        let content = content()
        
    }

    public var body: some View {
        GeometryReader { proxy in
            VStack {

            }
        }
    }
}
