//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import SwiftUI

public struct Graph2D: Shape, Identifiable {


    public let id: String

    public let points: [CGPoint]

    public let bounds: CGRect

    public init(id: String = UUID().uuidString, _ points: [CGPoint]) {
        self.id = id
        self.points = points

        let minX = points.min { $0.x < $1.x }?.x ?? 0
        let minY = points.min { $0.y < $1.y }?.y ?? 0
        let maxX = points.max { $0.x < $1.x }?.x ?? 0
        let maxY = points.max { $0.y < $1.y }?.y ?? 0
        let width = maxX - minX
        let height = maxY - minY
        self.bounds = CGRect(x: minX, y: minY, width: width, height: height)
    }

    public func path(in rect: CGRect) -> Path {
        Path { path in
            var points = points

            if !points.isEmpty {
                let firstPoint = points.removeFirst()
                path.move(to: firstPoint)

                while !points.isEmpty {
                    let currentPoint = points.removeFirst()
                    path.addLine(to: currentPoint)
                }
            }
        }
        
    }
}
