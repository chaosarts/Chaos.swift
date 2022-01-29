//
//  Matrix.swift
//  Pods
//
//  Created by Fu Lam Diep on 17.12.21.
//

import Foundation

public func randomFloatMatrix(width: Int, height: Int, range: Range<Float> = 0..<100) -> [Float] {
    (0..<(width * height)).map({ _ in Float.random(in: range) })
}

public func dump(matrix: [Float]?, width: Int, height: Int) {
    guard let matrix = matrix else {
        print("nil")
        return
    }

    var stringMatrix: [[String]] = []
    var maxStringLength = 0
    for y in 0..<height {
        var stringRow: [String] = []
        for x in 0..<width {
            let numberString = matrix[y * width + x].description
            maxStringLength = max(maxStringLength, numberString.count)
            stringRow.append(numberString)
        }
        stringMatrix.append(stringRow)
    }

    stringMatrix = stringMatrix.map({ $0.map { string in
        String(repeating: " ", count: maxStringLength - string.count) + string
    } })

    print(stringMatrix.map({ $0.joined(separator: " ") }).joined(separator: "\n"))
}
