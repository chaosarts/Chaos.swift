//
//  Task.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

public protocol Task: class {

    var id: String { get }

    func run () -> Promise<Void>
}


public class BlockTask: Task {

    public typealias Block = () -> Promise<Void>

    public let id: String

    private let block: Block

    public init (id: String, block: @escaping Block) {
        self.id = id
        self.block = block
    }

    public func run () -> Promise<Void> {
        block()
    }
}
