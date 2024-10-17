//
//  ChaosError.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 23.10.20.
//

import Foundation

public protocol ChaosError: CustomNSError, AnyObject {
    associatedtype Code: RawRepresentable where Code.RawValue == Int

    var code: Code { get }

    var previous: Error? { get }
}

public extension ChaosError {
    var errorCode: Int { code.rawValue }

    var descriptionKey: String { "\(Self.errorDomain).\(code.rawValue).description" }

    var localizedDescription: String {
        NSLocalizedString(descriptionKey,
                          tableName: moduleName(Self.self),
                          bundle: Bundle(for: Self.self),
                          comment: "")
    }
}
