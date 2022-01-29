
import XCTest
@testable import ChaosMetal

public class TransposeMatrixTests: XCTestCase {

    public var commandQueue: MTLCommandQueue!

    public override func setUp() {
        commandQueue = MTLCreateSystemDefaultDevice()?.makeCommandQueue()
        XCTAssertNotNil(commandQueue)
    }

    public func testExecute_transposeMatrix_returnsMatrixOfSameSize () {
        let width = 100
        let matrix = Array<Float>(repeating: 0, count: width * width)
        var output: [Float]?

        let expectation = XCTestExpectation(description: "GPU Transpose Matrix")
        gpu_transpose(matrix: matrix, width: width, inCommandQueue: commandQueue, completion: {
            output = $0
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(output?.count, matrix.count)
    }

    public func testExecute_transposeMatrix_returnsCorrectResult () {
        // Arrange
        let width = 100
        let matrix = (0..<(width * width)).map({ Float($0) })

        // Act
        let expectation = XCTestExpectation(description: "GPU Transpose Matrix")
        var gpu_output: [Float]?
        gpu_transpose(matrix: matrix, width: width, inCommandQueue: commandQueue, completion: {
            gpu_output = $0
            expectation.fulfill()
        })

        let cpu_output = cpu_transpose(matrix: matrix, width: width, height: width)

        wait(for: [expectation], timeout: 5)

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

    public func testPerformance_gpuTransposMatrix () {
        // Arrange
        let width = performanceTestWidth
        let matrix = performanceTestMatrix

        // Act

        measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true) {
            gpu_transpose(matrix: matrix, width: width, inCommandQueue: commandQueue, completion: { _ in
                self.stopMeasuring()
            })
        }
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
