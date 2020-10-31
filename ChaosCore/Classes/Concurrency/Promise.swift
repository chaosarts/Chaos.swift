//
//  Promise.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 06.06.19.
//

import Foundation
import Promises

public typealias GooglePromise = Promises.Promise

/** Promises are objects to execute asynchronous operations (e.g. url requests)
 and manages the execution of appropriate callback functions as soon as the async
 operation has finished.

 An instance of a promise can take several callbacks through different methods for
 different use-cases. Each call of these methods create a new promise, which in
 turn has also these methods. Hence a tree of promises can be build. The methods
 to pass a callback to a promise are:
 - `then()` takes callbacks, that are executed, when the promise is
 fulfilled/successful. The callback expects an object of type `Result`. The
 callback can return an object of arbitrary type or a promise (e.g. when another
 asyn operation needs to be executed) that resolves with an object of arbitrary
 type. Either way a callback passing to `then` on the new promise needs to expect
 the new type as parameter.
 - `catch()` takes callbacks, when the operation fails/rejects. Callbacks passed
 to this method expects an object of type `Error`. One can also specify the type
 of error by passing `type`. The callback will then only be executed, when the
 error matches this type. `catch`-callbacks can be called through many cases: the
 operation uses `reject` to resolve the promise. One of the promise ancestors
 were rejected or the any callback of `then` in the promise hierarchy from the
 current ancestor promises throws an error. There is one exception to the rule:
 One of the promises in the hierarchy created through `recover` and all other
 promises between such promise and the current promise fulfill. A callback passed
 to this method has the possibility to convert the error it gets as argument by
 throwing another error. The succeeding promise will continue executing its
 `catch` callbacks with this new error.
 - `recover()` takes callbacks to rescue error cases and continue fulfilling the
 rest of successor promises in the hierarchy. The callbacks passed to this method
 will be called for the same cases as for the callbacks passed to `catch`. To
 recover a promise the callback takes an error as argument (this can also be only
 for specific errors) and needs to return successfully an object of type `Result`.
 Callbacks may alsow throw errors and the chain of `catch` callbacks will
 continue.
 - `always()` takes callbacks, that needs to be called in any case. No matter how
 the promise resolves.

 Promises can also take callbacks even after they have resolved. The class
 executes the callbacks immediatley or disposes them, depending on the method
 called and the result of the promise.

 A promises is initialized with a callback. This callback is passed two functions:
 `fulfill` and `reject`. Exactly one of these function must be executed at some
 point, to signal the promise, that the operation has finished (successfully or
 not). When the operation is considered successfull `fulfill` should be called
 with an argument of the generic type `Result`. If the operation failed `reject`
 should be called with an appropriate error as argument. If the operation throws
 an error, `reject` is called automatically.

 If the root promise of promise tree has a cancelable operation the operation can
 cancled throught `cancel()` on the promise, otherwise the promise does nothing.
 */
open class Promise<Result>: Cancelable {

    /// Describes the callback signature for the fulfill callback passed on initialization.
    public typealias Fulfill = (Result) -> Void

    /// Describes the callback signature for the reject callback passed on initialization.
    public typealias Reject = (Error) -> Void

    /// Describes the callback signature for callbacks to pass on the `then` method.
    public typealias Then<NextResult> = (Result) throws -> NextResult

    /// Describes the callback signature for callbacks to pass on the `catch` method.
    public typealias TypedCatch<E: Error> = (E) throws -> Void

    public typealias Catch = (Error) throws -> Void

    /// Describes the callback signature for callbacks to pass on the `recover` method.
    public typealias Recover<E: Error> = (E) throws -> Result

    /// Describes the callback signature for callbacks to pass on the `always` method.
    public typealias Always = () -> Void

    public typealias Work = (@escaping Fulfill, @escaping Reject) throws -> Void

    public typealias CancelableWork = (@escaping Fulfill, @escaping Reject) throws -> Cancelable?


    // MARK: - Nested types

    /// Enumerates the different status values a promise can gain
    public enum Status {
        case pending
        case rejected
        case fulfilled
    }


    public static func void (_ any: Any? = nil) {
        return
    }

    // MARK: - Properties

    /// Provides the object, that is cancelable
    private var cancelable: Cancelable?

    /// Indicates, if the promise has been marked as canceled. This is needed,
    /// when the promise is created with a callback that returns a `Cancelabel`
    /// object. `cancel()` may be called right after creation and the cancelable
    /// may not be produced yet.
    public private(set) var canceled: Bool = false

    /// Provides the actual promise (by Google)
    fileprivate var promise: GooglePromise<Result> {
        didSet {
            promise.then { _ in self.status = .fulfilled }
            promise.catch { _ in self.status = .rejected }
        }
    }

    /// Provides the status of the promise
    public private(set) var status: Status = .pending

    /// Indicates, whether the promise is pending or resolved (fulfilled or rejected)
    public var resolved: Bool { return status != .pending }


    // MARK: - Initialization

    /// Initializes the promise with a cancelable process. For internal use only.
    private init (cancelable: Cancelable? = nil, promise: GooglePromise<Result>) {
        self.cancelable = cancelable
        self.promise = promise
    }


    /// Initializes the promise with a callback with asynchronous operations to
    /// be executed. The call back is given two function to either fulfill or
    /// reject the promise. It is up to the developer to call these resolver
    /// function at the right time. The return type of the callback is a optional
    /// cancelable object, that offers a method to cancel the whole async
    /// operations.
    public convenience init (on queue: DispatchQueue = .promises,
                             work: @escaping CancelableWork) {
        self.init(promise: GooglePromise<Result> {})
        self.promise = GooglePromise<Result>(on: queue) {
            if self.canceled { throw PromiseError.canceled }
            self.cancelable = try work($0, $1)
        }
    }

    /// Initializes the promise with the given callback, that perform possibly
    /// asynchronous work and resolve this issue, when ready.
    ///
    /// The callback is given two functions to resolve the promise, either fulfill
    /// or reject. The promise is not cancelable.
    public convenience init (on queue: DispatchQueue = .promises, work: @escaping Work) {
        let promise = GooglePromise<Result>(on: queue, work)
        self.init(promise: promise)
    }

    /// Initializes a rejected promise with given error.
    public convenience init (error: Swift.Error) {
        let promise = GooglePromise<Result>(error)
        self.init(promise: promise)
    }

    /// Initializes a fulfilled promise with given value.
    public convenience init (value: Result) {
        let promise = GooglePromise<Result>(value)
        self.init(promise: promise)
    }


    // MARK: - Preserving Callbacks and Promise Chaining

    @discardableResult
    public func then<NextResult> (on queue: DispatchQueue = .promises,
                                  _ callback: @escaping Then<NextResult>) -> Promise<NextResult> {
        let promise = self.promise.then(on: queue, callback)
        return Promise<NextResult>(cancelable: self, promise: promise)
    }

    @discardableResult
    public func then<NextResult> (on queue: DispatchQueue = .promises,
                                  _ callback: @escaping Then<Promise<NextResult>>) -> Promise<NextResult> {
        let promise = self.promise.then(on: queue) { try callback($0).promise }
        return Promise<NextResult>(cancelable: self, promise: promise)
    }

    @discardableResult
    public func `catch`<E: Error> (type: E.Type, on queue: DispatchQueue = .promises,
                                   _ callback: @escaping TypedCatch<E>) -> Promise {
        let promise = self.promise.recover(on: queue) { error -> Result in
            if let e = error as? E { try callback(e) }
            throw error
        }
        return Promise(cancelable: self, promise: promise)
    }

    @discardableResult
    public func `catch`(on queue: DispatchQueue = .promises,
                        _ callback: @escaping Catch) -> Promise {
        let promise = self.promise.recover(on: queue, { error -> Result in
            try callback(error)
            throw error
        })
        return Promise(cancelable: self, promise: promise)
    }

    @discardableResult
    public func recover<E: Error>(from type: E.Type, on queue: DispatchQueue = .promises,
                                  _ callback: @escaping Recover<E>) -> Promise<Result> {
        let promise = self.promise.recover(on: queue, { error -> Result in
            if let e = error as? E { return try callback(e) }
            throw error
        })
        return Promise(cancelable: self, promise: promise)
    }

    @discardableResult
    public func recover<E: Error>(from type: E.Type, on queue: DispatchQueue = .promises,
                                  _ callback: @escaping (E) throws -> Promise<Result>) -> Promise<Result> {
        let promise = self.promise.recover(on: queue) { error -> GooglePromise<Result> in
            if let e = error as? E { return try callback(e).promise }
            throw error
        }
        return Promise(cancelable: self, promise: promise)
    }

    @discardableResult
    public func recover(on queue: DispatchQueue = .promises,
                        _ callback: @escaping (Error) throws -> Result) -> Promise<Result> {
        let promise = self.promise.recover(on: queue, callback)
        return Promise(cancelable: self, promise: promise)
    }

    @discardableResult
    public func recover(on queue: DispatchQueue = .promises,
                        _ callback: @escaping (Error) throws -> Promise) -> Promise<Result> {
        let promise = self.promise.recover(on: queue, {
            try callback($0).promise
        })
        return Promise(cancelable: cancelable, promise: promise)
    }

    @discardableResult
    public func always (on queue: DispatchQueue = .promises,
                        _ callback: @escaping Always) -> Promise {
        let promise = self.promise.always(on: queue, callback)
        return Promise(cancelable: self, promise: promise)
    }

    // MARK: - Cancelable Implementation

    public func cancel() {
        guard !resolved else { return }

        canceled = true

        if let cancelable = cancelable {
            cancelable.cancel()
        }
    }
}

public extension Promise where Result == Void {
    convenience init () {
        let void: Void
        self.init(value: void)
    }
}


public func all<A, B> (on queue: DispatchQueue = .promises, _ a: Promise<A>, _ b: Promise<B>) -> Promise<(A, B)> {
    return Promise<(A, B)>(on: queue) { fulfill, reject -> Void in
        let promise = Promises.all(a.promise, b.promise)
        promise.then {
            fulfill(($0, $1))
        }
        promise.catch {
            reject($0)
        }
    }
}


public func all<A, B, C> (on queue: DispatchQueue = .promises, _ a: Promise<A>, _ b: Promise<B>, _ c: Promise<C>) -> Promise<(A, B, C)> {
    return Promise<(A, B, C)>(on: queue) { fulfill, reject -> Void in
        let promise = Promises.all(a.promise, b.promise, c.promise)
        promise.then { fulfill(($0, $1, $2)) }
        promise.catch { reject($0) }
    }
}
