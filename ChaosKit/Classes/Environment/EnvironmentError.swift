//
//  EnvironmentError.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

/// Error class for operations regarding environments
public class EnvironmentError: Error {

    /// Provudes the code of the error to serve a context
    public let code: Code

    /// Provides an optional message for debugging
    public let message: String?

    /// Provides an optional error, that may have caused the environment error
    public let previous: Error?

    
    public init(code: Code, message: String? = nil, previous: Error? = nil) {
        self.code = code
        self.message = message
        self.previous = previous
    }
}


public extension EnvironmentError {
    @objc
    public enum Code: Int {
        case environmentsFileNotFound
        case importFailed
        case loadingEnvironmentsFailed
        case noUserDefaultsEntryFound

        case autoSelectFailed
        case invalidEnvironmentIdentifier
        case invalidEnvironmentIndex
        case setupFailed

        case `internal`
    }
}
