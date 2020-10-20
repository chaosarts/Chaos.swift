//
//  String+CodingKey.swift
//  INITCore
//
//  Created by Fu Lam Diep on 15.11.19.
//

import Foundation

/*
 This extension provides the implementation for coding key to use String objects as coding keys right away.
 */
extension String: CodingKey {

    // MARK: - CodingKey implementation

    // MARK: Properties

    public var stringValue: String { self }

    public var intValue: Int? { Int(self) }


    // MARK: Initialization

    public init?(intValue: Int) {
        self.init(intValue.description)
    }


    public init?(stringValue: String) {
        self.init(stringValue)
    }
}
