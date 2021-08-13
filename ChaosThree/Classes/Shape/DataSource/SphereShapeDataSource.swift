//
//  SphereDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 06.07.21.
//

import Foundation
import ChaosMath

open class SphereShapeDataSource: ShapeDataSource {

    // MARK: Configuration Properties

    /// Provides the center of the sphere
    public var center: Vec3 {
        didSet { setNeedsUpdate() }
    }

    /// Provides the radius of the sphere
    public var radius: Vec3.Component {
        didSet { setNeedsUpdate() }
    }

    /// Specifies the number of latitudes (east to west) along a longitude excluding polars.
    public var latitudeCount: Int {
        didSet { setNeedsUpdate() }
    }

    /// Specifies the number of longitudes (north to south) along a latitude.
    public var longitudeCount: Int {
        didSet { setNeedsUpdate() }
    }


    // MARK: Cache Properties

    /// Provides the spacing between latitudes in radians.
    private var latitudeSpacing: Float = 0.0

    /// Provides the spacing between longitudes in radians.
    private var longitudeSpacing: Float = 0.0

    /// Provides the number of line segments per longitude. This is the count of latitudes plus one.
    private var lineSegmentsPerLongitude: Int = 0

    private var linesPerLatitude: Int = 0

    private var needsUpdate: Bool = true

    public init (center: Vec3 = Vec3(), radius: Vec3.Component = 1.0, latCount: Int = 9, lonCount: Int = 10) {
        self.center = center
        self.radius = radius
        self.latitudeCount = latCount
        self.longitudeCount = lonCount
    }

    public func numberOfPrimitives(_ shape: Shape, forType primitiveType: Shape.Primitive) -> Int {
        updateIfNeeded()
        switch primitiveType {
        case .point:
            return latitudeCount * longitudeCount + 2
        case .line:
            return longitudeCount * (2 * latitudeCount + 1)
        case .triangle:
            return latitudeCount * longitudeCount * 2
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
        } else if index == latitudeCount * longitudeCount + 2 {
            return center + Vec3(0, -1, 0) * radius
        }

        let rasterIndex = index - 1
        let lonIndex = rasterIndex % latitudeCount
        let latIndex = (rasterIndex - lonIndex) / latitudeCount

        return vertexAt(latIndex: latIndex, lonIndex: lonIndex)
    }

    private func line (at index: Int) -> [Vec3] {
        let totalNumberOfLonLines = lineSegmentsPerLongitude * longitudeCount

        if index < totalNumberOfLonLines  {
            let latIndex = index % lineSegmentsPerLongitude
            let lonIndex = (index - latIndex) / lineSegmentsPerLongitude
            return [vertexAt(latIndex: latIndex, lonIndex: lonIndex), vertexAt(latIndex: latIndex + 1, lonIndex: lonIndex)]
        } else {
            let lonIndex =  index % linesPerLatitude
            let latIndex = (index - lonIndex) / linesPerLatitude
            return [vertexAt(latIndex: latIndex, lonIndex: lonIndex), vertexAt(latIndex: latIndex, lonIndex: lonIndex + 1)]
        }
    }

    private func triangle (at index: Int) -> [Vec3] {
        if index < longitudeCount {
            // North
            return [Vec3(), vertexAt(latIndex: 1, lonIndex: index), vertexAt(latIndex: 1, lonIndex: index + 1)]
        } else if index < longitudeCount + longitudeCount * 2 * (latitudeCount - 1) {
            return []
        } else {
            // South
            return []
        }
    }

    private func vertexAt (latIndex: Int, lonIndex: Int) -> Vec3 {
        let theta = Float(latIndex + 1) * latitudeSpacing
        let phi = Float(lonIndex % longitudeCount) * longitudeSpacing

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
        lineSegmentsPerLongitude = latitudeCount + 1
        linesPerLatitude = longitudeCount

        latitudeSpacing = .pi / Float(lineSegmentsPerLongitude)
        longitudeSpacing = (2 * .pi) / Float(longitudeCount)
    }
}
