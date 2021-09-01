//
//  RestResult.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 19.08.21.
//

import Foundation

public enum RestResult<D> {
    case success(D)
    case failure(Error)
}
