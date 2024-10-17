//
//  MTLDevice+Extensions.swift
//  Pods
//
//  Created by Fu Lam Diep on 30.12.21.
//

import Foundation
import Metal

public extension MTLDevice {

    func makeChaosMetalDefaultLibrary () throws -> MTLLibrary {
        do {
            let bundle = Bundle(for: ChaosMetalError.self)
            return try makeDefaultLibrary(bundle: bundle)
        } catch {
            throw ChaosMetalError(code: .noLibrary, previous: error)
        }
    }
}
