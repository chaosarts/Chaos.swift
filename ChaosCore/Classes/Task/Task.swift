//
//  Task.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 22.10.20.
//

import Foundation

/// Protocol that describes a task.
public protocol Task: AnyObject {

    /// Provides the id of the task.
    var id: String { get }

    /// Invokes the task to run and return a promise, that resolves as soon as the
    /// task has finished.
    func run () -> Promise<Void>
}


// MARK: - Predefined Implementations

/// A `Task` implementation, that can take any callback function with `Block`
/// signature. Instead of implementing a new task class for every simple task to
/// run, use this class to implement the run method on place with lambda
/// functions.
public class BlockTask: Task {

    /// Describes the signature of the lambda function to pass to the `init`
    /// function.
    public typealias Block = () -> Promise<Void>

    /// The id of the task
    public let id: String

    public var preserveResult: Bool

    /// Provides the lambda function to execute, when calling `run`
    private let block: Block

    /// When `preserveResult` is `true`, this provides the resulting promise,
    /// returned by `block`, when invoked. If `run` is called a second time this
    /// promise is returned.
    private var promise: Promise<Void>?

    /// Initializes the block task with given id and a `Block` lambda function to
    /// execute in run.
    public init (id: String, preserveResult: Bool, block: @escaping Block) {
        self.id = id
        self.block = block
        self.preserveResult = preserveResult
    }

    /// Invokes the task to run the block passed to the initializer
    public func run () -> Promise<Void> {
        if preserveResult {
            let promise = self.promise ?? block()
            self.promise = promise
            return promise
        }
        return block()
    }

    public func flush () {
        self.promise = nil
    }
}
