//
//  SphereDataSource.swift
//  ChaosThree
//
//  Created by Fu Lam Diep on 06.07.21.
//

import Foundation
import ChaosMath

public class SphereMeshDataSource: MeshDataSource {

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

    // Indicates whether the cache properties needs to be updated or not.
    private var needsUpdate: Bool = true


    // MARK: Initialization

    public init (center: Vec3 = Vec3(), radius: Vec3.Component = 1.0, latCount: Int = 9, lonCount: Int = 10) {
        self.center = center
        self.radius = radius
        self.latitudeCount = latCount
        self.longitudeCount = lonCount
    }


    // MARK: ShapeDataSource Implementations

    public func mesh(_ mesh: Mesh, verticesFor primitive: Mesh.PrimitiveType) -> [Vec3] {
        updateIfNeeded()
        switch primitive {
        case .point:
            return verticesForPoints()
        case .line:
            return verticesForLines()
        case .triangle:
            return verticesForTriangles()
        }
    }

    private func verticesForPoints () -> [Vec3] {
        var vertices: [Vec3] = []
        vertices.append(center + Vec3(0, 1, 0) * radius)

        for lat in 0..<latitudeCount {
            for lon in 0..<longitudeCount {
                vertices.append(vertexAt(latIndex: lat, lonIndex: lon))
            }
        }

        vertices.append(center + Vec3(0, -1, 0) * radius)
        return vertices
    }

    private func verticesForLines () -> [Vec3] {
        var vertices: [Vec3] = []


        // Generate latitudes

        for lat in 0..<latitudeCount {
            for lon in 0..<longitudeCount {
                vertices.append(vertexAt(latIndex: lat, lonIndex: lon))
                vertices.append(vertexAt(latIndex: lat, lonIndex: lon + 1))
            }
        }


        // Generate longitudes

        let north = center + Vec3(0, 1, 0) * radius
        let south = center + Vec3(0, -1, 0) * radius

        for lon in 0..<longitudeCount {

            vertices.append(north)
            vertices.append(vertexAt(latIndex: 0, lonIndex: lon))

            for lat in 0..<(latitudeCount - 1) {
                vertices.append(vertexAt(latIndex: lat, lonIndex: lon))
                vertices.append(vertexAt(latIndex: lat + 1, lonIndex: lon))
            }

            vertices.append(vertexAt(latIndex: latitudeCount - 1, lonIndex: lon))
            vertices.append(south)
        }

        vertices.append(center + Vec3(0, -1, 0) * radius)
        return vertices
    }

    private func verticesForTriangles () -> [Vec3] {
        var vertices: [Vec3] = []


        // North Polar Cap

        for longitudeIndex in 0..<longitudeCount {
            vertices.append(center + Vec3(0, 1, 0) * radius)
            vertices.append(vertexAt(latIndex: 0, lonIndex: longitudeIndex))
            vertices.append(vertexAt(latIndex: 0, lonIndex: longitudeIndex + 1))
        }


        // Body

        for latitudeIndex in 0..<(latitudeCount - 1) {
            for longitudeIndex in 0..<longitudeCount {
                vertices.append(vertexAt(latIndex: latitudeIndex, lonIndex: longitudeIndex))
                vertices.append(vertexAt(latIndex: latitudeIndex + 1, lonIndex: longitudeIndex))
                vertices.append(vertexAt(latIndex: latitudeIndex, lonIndex: longitudeIndex + 1))

                vertices.append(vertexAt(latIndex: latitudeIndex, lonIndex: longitudeIndex + 1))
                vertices.append(vertexAt(latIndex: latitudeIndex + 1, lonIndex: longitudeIndex))
                vertices.append(vertexAt(latIndex: latitudeIndex + 1, lonIndex: longitudeIndex + 1))
            }
        }


        // South Polar Cap

        let lastLatitudeIndex = latitudeCount - 1
        for longitudeIndex in 0..<longitudeCount {
            vertices.append(vertexAt(latIndex: lastLatitudeIndex, lonIndex: longitudeIndex))
            vertices.append(center + Vec3(0, -1, 0) * radius)
            vertices.append(vertexAt(latIndex: lastLatitudeIndex, lonIndex: longitudeIndex + 1))
        }

        return vertices
    }

    private func vertexAt (latIndex: Int, lonIndex: Int) -> Vec3 {
        let theta = Float(latIndex + 1) * latitudeSpacing
        let phi = Float(lonIndex) * longitudeSpacing

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
        latitudeSpacing = .pi / Float(latitudeCount + 1)
        longitudeSpacing = (2 * .pi) / Float(longitudeCount)
    }
}
