//
//  Copyright © 2025 Fu Lam Diep <fulam.diep@gmail.com>
//

import Testing
@testable import ChaosMath

struct SeriesTests {
    @Test func exclusiveScan() {
        #expect(ChaosMath.exclusiveScan([1, 1, 1, 1, 1, 1, 1, 1]) == [0, 1, 2, 3, 4, 5, 6, 7])
        #expect(ChaosMath.exclusiveScan([10, 20, 10, 5, 15]) == [0, 10, 30, 40, 45])
    }

    @Test func inclusiveScan() {
        #expect(ChaosMath.inclusiveScan([1, 1, 1, 1, 1, 1, 1, 1]) == [1, 2, 3, 4, 5, 6, 7, 8])
        #expect(ChaosMath.inclusiveScan([10, 20, 10, 5, 15]) == [10, 30, 40, 45, 60])
    }

    @Test func scan() {
        #expect(ChaosMath.scan([10, 20, 10, 5, 15], inclusive: true) == [10, 30, 40, 45, 60])
        #expect(ChaosMath.scan([10, 20, 10, 5, 15]) == [10, 30, 40, 45, 60])
        #expect(ChaosMath.scan([10, 20, 10, 5, 15], inclusive: false) == [0, 10, 30, 40, 45])
    }
}
