//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 26.07.24.
//

import SwiftUI

public struct Slider<Stop>: View where Stop: BinaryFloatingPoint {
    
    @Binding private var stops: [Stop]
    
    private let range: ClosedRange<Stop>
    
    private let drawerSize: CGFloat = 24
    
    private let coordinateSpaceName: String = "Slider"
    
    public init(_ stops: Binding<[Stop]>, range: ClosedRange<Stop>) {
        assert(stops.count > 0)
        assert(stops.wrappedValue.sorted { $0 < $1 } == stops.wrappedValue)
        assert(stops.wrappedValue.allSatisfy { range.contains($0) })
        
        _stops = stops
        self.range = range
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let drawerRadius = drawerSize / 2
            let drawerFrame = proxy.frame(in: .named(coordinateSpaceName))
                .insetBy(dx: drawerRadius, dy: 0)
            let scale = drawerFrame.width / CGFloat(range.upperBound - range.lowerBound)
            let translation = (drawerFrame.minX) - CGFloat(range.lowerBound) * scale
            let drawerPositions = stops.map {
                CGFloat($0) * scale + translation
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(maxHeight: 6)
                    .foregroundColor(.gray)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.blue)
                            .mask(Capsule())
                    }
                
                ForEach(0..<stops.count, id: \.self) { index in
                    let stop = $stops[index]
                    let drawerPosition = drawerPositions[index]
                    Circle().frame(width: drawerSize, height: drawerSize)
                        .position(x: drawerPosition, y: drawerFrame.height / 2)
                        .gesture(
                            DragGesture(coordinateSpace: .named(coordinateSpaceName))
                                .onChanged({ value in
                                    let stopValue = Stop((value.location.x - translation) / scale)
                                    stop.wrappedValue = min(range.upperBound, max(range.lowerBound, stopValue))
                                })
                        )
                }
            }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

public protocol SliderStyle {
    associatedtype Body: View
    func makeBody(_ positions: [CGFloat], in frame: CGRect) -> Body
}

#Preview {
    struct SliderExampleView: View {
        
        @State var stops: [Float] = [-100, 100]
        
        var body: some View {
            Slider($stops, range: -100...100)
        }
    }
    
    return SliderExampleView()
        .padding()
}
