//
//  File.swift
//  
//
//  Created by fu.lam.diep on 29.07.23.
//

import Foundation

@resultBuilder public struct ChartContentBuilder {

    public static func buildExpression<Content>(_ expression: Content) -> Content where Content: ChartContent {
        expression
    }

    public static func buildBlock() -> EmptyChartContent {
        EmptyChartContent()
    }

    public static func buildBlock<Content>(_ component: Content) -> Content where Content: ChartContent {
        component
    }

    public static func buildEither<Content>(first component: Content) -> Content {
        component
    }

    public static func buildEither<Content>(second component: Content) -> Content {
        component
    }

    public static func buildOptional<Content>(_ component: Content?) -> Content? {
        component
    }

    public static func buildBlock<C1, C2>(_ c1: C1, _ c2: C2) -> TupleChartContent<(C1, C2)> {
        TupleChartContent((c1, c2))
    }

    public static func buildBlock<C1, C2, C3>(_ c1: C1, _ c2: C2, _ c3: C3) -> TupleChartContent<(C1, C2, C3)> {
        TupleChartContent((c1, c2, c3))
    }

    public static func buildBlock<C1, C2, C3, C4>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> TupleChartContent<(C1, C2, C3, C4)> {
        TupleChartContent((c1, c2, c3, c4))
    }

    public static func buildBlock<C1, C2, C3, C4, C5>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> TupleChartContent<(C1, C2, C3, C4, C5)> {
        TupleChartContent((c1, c2, c3, c4, c5))
    }

    public static func buildBlock<C1, C2, C3, C4, C5, C6>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> TupleChartContent<(C1, C2, C3, C4, C5, C6)> {
        TupleChartContent((c1, c2, c3, c4, c5, c6))
    }

    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> TupleChartContent<(C1, C2, C3, C4, C5, C6, C7)> {
        TupleChartContent((c1, c2, c3, c4, c5, c6, c7))
    }

    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> TupleChartContent<(C1, C2, C3, C4, C5, C6, C7, C8)> {
        TupleChartContent((c1, c2, c3, c4, c5, c6, c7, c8))
    }

    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> TupleChartContent<(C1, C2, C3, C4, C5, C6, C7, C8, C9)> {
        TupleChartContent((c1, c2, c3, c4, c5, c6, c7, c8, c9))
    }

    public static func buildBlock<C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>(_ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10) -> TupleChartContent<(C1, C2, C3, C4, C5, C6, C7, C8, C9, C10)> {
        TupleChartContent((c1, c2, c3, c4, c5, c6, c7, c8, c9, c10))
    }
}
