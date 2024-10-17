//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.22.
//

import Foundation

public extension Result {

    var success: Success? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    var failure: Failure? {
        guard case .failure(let error) = self else { return nil }
        return error
    }
}
