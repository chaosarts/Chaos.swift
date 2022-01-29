//
//  RestError.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

public protocol RestError: CustomNSError {
    associatedtype Code: RawRepresentable where Code.RawValue == Int

    var code: Code { get }
}

public extension RestError {
    var errorCode: Int { code.rawValue }
}
