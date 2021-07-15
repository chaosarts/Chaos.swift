//
//  SphereDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 06.07.21.
//

import Foundation
import ChaosMath

open class SphereShapeDataSource: ShapeDataSource {    

    public var center: Vec3 {
        didSet { setNeedsUpdate() }
    }

    public var radius: Vec3.Component {
        didSet { setNeedsUpdate() }
    }

    public var latCount: Int {
        didSet { setNeedsUpdate() }
    }

    public var lonCount: Int {
        didSet { setNeedsUpdate() }
    }

    public var latSpacing: Float = 0.0

    public var lonSpacing: Float = 0.0

    private var linesPerLon: Int = 0

    private var linesPerLat: Int = 0

    private var needsUpdate: Bool = true

    public init (center: Vec3 = Vec3(), radius: Vec3.Component = 1.0, latCount: Int = 9, lonCount: Int = 10) {
        self.center = center
        self.radius = radius
        self.latCount = latCount
        self.lonCount = lonCount
    }

    public func numberOfPrimitives(_ shape: Shape, forType primitiveType: Shape.Primitive) -> Int {
        updateIfNeeded()
        switch primitiveType {
        case .point:
            return latCount * lonCount + 2
        case .line:
            return lonCount * (2 * latCount + 1)
        case .triangle:
            return latCount * lonCount * 2
        }
    }

    public func shape(_ shape: Shape, verticesForPrimitiveAt index: Int, ofType primitiveType: Shape.Primitive) -> [Vec3] {
        switch primitiveType {
        case .point:
            return [point(at: index)]
        default:
            fatalError()
        }
    }

    private func point (at index: Int) -> Vec3 {
        if index == 0 {
            return center + Vec3(0, 1, 0) * radius
        } else if index == latCount * lonCount + 2 {
            return center + Vec3(0, -1, 0) * radius
        }

        let rasterIndex = index - 1
        let lonIndex = rasterIndex % latCount
        let latIndex = (rasterIndex - lonIndex) / latCount

        return vertexAt(latIndex: latIndex, lonIndex: lonIndex)
    }

    private func line (at index: Int) -> [Vec3] {
        let totalNumberOfLonLines = linesPerLon * lonCount

        if index < totalNumberOfLonLines  {
            let latIndex = index % linesPerLon
            let lonIndex = (index - latIndex) / linesPerLon
            return [vertexAt(latIndex: latIndex, lonIndex: lonIndex), vertexAt(latIndex: latIndex + 1, lonIndex: lonIndex)]
        } else {
            let lonIndex =  index % linesPerLat
            let latIndex = (index - lonIndex) / linesPerLat
            return [vertexAt(latIndex: latIndex, lonIndex: lonIndex), vertexAt(latIndex: latIndex, lonIndex: lonIndex + 1)]
        }
    }

    private func triangle (at index: Int) -> [Vec3] {
        if index < lonCount {
            // North
            return [Vec3(), vertexAt(latIndex: 1, lonIndex: index), vertexAt(latIndex: 1, lonIndex: index + 1)]
        } else if index < lonCount + lonCount * 2 * (latCount - 1) {
            return []
        } else {
            // South
            return []
        }
    }

    private func vertexAt (latIndex: Int, lonIndex: Int) -> Vec3 {
        let theta = Float(latIndex + 1) * latSpacing
        let phi = Float(lonIndex % lonCount) * lonSpacing

        let x = radius * sin(theta) * cos(phi)
        let y = radius * sin(theta) * sin(phi)
        let z = radius * cos(theta)

        return Vec3(x, y, z)
    }

    private func setNeedsUpdate () {
        needsUpdate = true
    }

    private func updateIfNeeded () {
        guard needsUpdate else { return }
        update()
    }

    private func update () {
        linesPerLon = latCount + 1
        linesPerLat = lonCount

        latSpacing = .pi / Float(linesPerLon)
        lonSpacing = (2 * .pi) / Float(lonCount)
    }
}
