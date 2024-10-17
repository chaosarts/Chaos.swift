//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 29.01.22.
//

import Foundation

public extension Optional {
    mutating func setIfNil(_ value: @autoclosure () -> Wrapped) {
        self = self ?? value()
    }
}
