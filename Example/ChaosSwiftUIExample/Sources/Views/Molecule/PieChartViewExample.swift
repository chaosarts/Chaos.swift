//
//  PieChartViewExample.swift
//  ChaosSwiftUIExample
//
//  Created by Fu Lam Diep on 08.10.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import ChaosSwiftUI

public struct PieChartViewExample: View {

    @State var segments: [PieChartView.Segment] = [
        .init(value: 1, color: .random())
    ]

    @State var isVisible: Bool = false

    public var body: some View {
        VStack(spacing: 10) {
            PieChartView(segments: $segments)
                .innerRadius(10)
                .radius(100)
            Button("Change Segment", action: {
                withAnimation {
                    guard !segments.isEmpty else { return }
                    segments[.random(in: 0..<segments.count)] = .init(value: .random(in: 0..<3), color: .random())
                }
            })

            Button("Add Segment", action: {
                segments.append(.init(value: 0, visible: true, color: .random()))
                withAnimation {
                    segments[segments.count - 1].value = .random(in: 0..<3)
                }
            })

            Button("Delete Segment", action: {
                withAnimation {
                    segments = segments.dropLast()
                }
            })

            Button("Hide Segment", action: {
                withAnimation {
                    guard !segments.isEmpty else { return }
                    segments[.random(in: 0..<segments.count)].visible = false
                }
            })

            Button("Show Segments", action: {
                withAnimation {
                    guard !segments.isEmpty else { return }
                    for index in 0..<segments.count {
                        segments[index].visible = true
                    }
                }
            })
        }
    }
}
