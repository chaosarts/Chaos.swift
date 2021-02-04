//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.21.
//

import Foundation

@objc public protocol Resolvable: class {
    @objc static optional var profile: String { get }
    @objc static optional var profiles: [String] { get }
    @objc static optional var singleton: Bool { get }

    init ()
}
