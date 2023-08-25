
import XCTest
@testable import ChaosMetal

public class TransposeMatrixTests: XCTestCase {

    public var commandQueue: MTLCommandQueue!

    public override func setUp() {
        commandQueue = MTLCreateSystemDefaultDevice()?.makeCommandQueue()
        XCTAssertNotNil(commandQueue)
    }

    public func testExecute_transposeMatrix_returnsMatrixOfSameSize () async {
        let width = 100
        let matrix = Array<Float>(repeating: 0, count: width * width)
        let expectation = XCTestExpectation(description: "GPU Transpose Matrix")
        let output = try? await gpu_transpose(matrix: matrix, width: width, inCommandQueue: commandQueue)

        XCTAssertEqual(output?.count, matrix.count)
    }

    public func testExecute_transposeMatrix_returnsCorrectResult () async {
        // Arrange
        let width = 100
        let matrix = (0..<(width * width)).map({ Float($0) })

        // Act
        let expectation = XCTestExpectation(description: "GPU Transpose Matrix")
        let gpu_output = try? await gpu_transpose(matrix: matrix, width: width, inCommandQueue: commandQueue)
        let cpu_output = cpu_transpose(matrix: matrix, width: width, height: width)

        var diffIndices = [Int]()
        for index in 0..<matrix.count {
            guard gpu_output?[index] != cpu_output[index] else { continue }
            diffIndices.append(index)
        }

        // Assert

        XCTAssertEqual(diffIndices.count, 0)
    }


    private let performanceTestWidth = 5000
    private let performanceTestMatrix: [Float] = (0..<(5000 * 5000)).map({ Float($0) })

    public func testPerformance_gpuTransposMatrix () async {
        // Arrange
        let width = performanceTestWidth
        let matrix = performanceTestMatrix

        // Act

        try? await gpu_transpose(matrix: matrix, width: width, inCommandQueue: commandQueue)
    }

    public func testPerformance_cpuTransposMatrix () {
        // Arrange
        let width = performanceTestWidth
        let matrix = performanceTestMatrix

        // Act
        measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true) {
            cpu_transpose(matrix: matrix, width: width, height: width)
            stopMeasuring()
        }
    }

    @discardableResult
    public func cpu_transpose(matrix: [Float], width: Int, height: Int) -> [Float] {
        var output = [Float](repeating: 0, count: width * height)
        for x in 0..<width {
            for y in 0..<height {
                output[x * width + y] = matrix[y * width + x]
            }
        }
        return output
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
}
