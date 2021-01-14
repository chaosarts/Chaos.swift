//
//  EnvironmentManager.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation
import ChaosCore

private let kEnvironmentsUserDefaults = "Environments"
private let kSelectedEnvironmentUserDefaults = "SelectedEnvironment"

@objc
public final class EnvironmentManager: NSObject {

    public static let instance: EnvironmentManager = EnvironmentManager()

    // MARK: Properties

    /// Provides the delegate to use to inform about events or to ask for
    /// app specific informations.
    public weak var delegate: EnvironmentManagerDelegate?

    /// Provides the decoder to use for decoding environments from file.
    public var fileImportDecoder: EnvironmentDataDecoder

    /// Provides the list of environments.
    private var environments: [Environment] = []

    /// Provides the id of tha last selected environment.
    private var lastSelectedEnvironmentId: String? {
        get { UserDefaults.environmentManager.string(forKey: kSelectedEnvironmentUserDefaults) }
        set { UserDefaults.environmentManager.setValue(newValue, forKey: kSelectedEnvironmentUserDefaults) }
    }

    /// Provides the currently selected envrionment
    private var selectedEnvironment: Environment? {
        didSet {  lastSelectedEnvironmentId = selectedEnvironment?.identifier }
    }

    /// Provides the internal index of the environment, that is currently
    /// selected.
    public var selectedEnvironmentIndex: Int? {
        guard let selectedEnvironment = selectedEnvironment else { return nil }
        return environments.firstIndex(where: { $0 === selectedEnvironment })
    }

    /// Provides the identifier of the currently selected environment.
    public var selectedEnvironmentIdentifier: String? {
        guard let selectedEnvironment = selectedEnvironment else { return nil }
        return selectedEnvironment.identifier
    }

    /// Provides the index of the currently executed setup task
    private var environmentSetupTasksIndex: Int = 0

    /// Provides a promise that resolves, when the selected environment is
    /// completely setup.
    private var setupPromise: Promise<Void>?


    // MARK: Decoding and Encoding Properties

    /// Provides the object to use for encoding environment objects in order to
    /// persist to the user defaults.
    private var userDefaultEncoder: JSONEncoder = JSONEncoder()

    /// Provides the object to use for decoding environment objects loaded from
    /// user defaults.
    private var userDefaultDecoder: JSONDecoder = JSONDecoder()


    // MARK: Initialization

    private override init () {
        let fileImportDecoder = PropertyListDecoder()
        self.fileImportDecoder = fileImportDecoder

        let userDefaultEncoder = JSONEncoder()
        userDefaultEncoder.dateEncodingStrategy = .iso8601
        self.userDefaultEncoder = userDefaultEncoder

        let userDefaultDecoder = JSONDecoder()
        userDefaultDecoder.dateDecodingStrategy = .iso8601
        self.userDefaultDecoder = userDefaultDecoder
    }


    // MARK: Managing Environments

    /// Loads the environment configurations from disk and imports into the
    /// application storage (UserDefaults) and loads into the internal storage.
    public func loadEnvironments<E: Environment> (ofType type: E.Type, fromFile filename: String = "environments", in bundle: Bundle = .main) throws {
        do {
            if #available(iOS 8, *) {
                let environments = try self.environments(ofType: type, fromFile: filename, in: bundle)
                try storeEnvironments(environments)
            }

            guard let data = UserDefaults.environmentManager.data(forKey: kEnvironmentsUserDefaults) else {
                throw EnvironmentError(code: .noUserDefaultsEntryFound)
            }

            environments = try userDefaultDecoder.decode([E].self, from: data)
        } catch (let error as EnvironmentError) {
            throw error
        } catch {
            throw EnvironmentError(code: .loadingEnvironmentsFailed, previous: error)
        }
    }

    /// For Unit Test only
    internal func removeSelection () {
        selectedEnvironment = nil
    }

    /// Reads and decode the environment configurations from a file and stores
    /// them to the user defaults.
    @available(iOS 8, *)
    private func environments<E: Environment> (ofType type: E.Type, fromFile filename: String = "environments", in bundle: Bundle = .main) throws -> [E] {
        guard let path = bundle.path(forResource: filename, ofType: fileImportDecoder.fileExtension),
              let data = FileManager.default.contents(atPath: path) else {
            throw EnvironmentError(code: .environmentsFileNotFound)
        }
        return try fileImportDecoder.decode([E].self, from: data)
    }

    /// Stores the list of environments in the user defaults.
    private func storeEnvironments<E: Environment> (_ environments: [E]) throws {
        let data = try userDefaultEncoder.encode(environments)
        UserDefaults.environmentManager.setValue(data, forKey: kEnvironmentsUserDefaults)
    }


    // MARK: Environment Selection and Setup

    /// Attempts to select an environment automatically.
    ///
    /// This succeeds either when only one environment is provided or a stored
    /// environment id is found in the persistence and an environment can be found
    /// in the imported list matching this id. Finally the determined environment
    /// must set up successfully.
    public func autoSelect (forceSetup: Bool = false) -> Promise<Void> {
        if let selectedEnvironment = selectedEnvironment {
            return select(identifier: selectedEnvironment.identifier, forceSetup: forceSetup)
        }

        if let lastSelectedEnvironmentId = lastSelectedEnvironmentId,
           let environment = environments.first(where: { $0.identifier == lastSelectedEnvironmentId }) {
            return select(identifier: environment.identifier, forceSetup: forceSetup)
        }

        if environments.count == 1 {
            return select(identifier: environments[0].identifier, forceSetup: forceSetup)
        }

        return Promise(error: EnvironmentError(code: .autoSelectFailed))
    }

    /// Selects and sets up the environment at given index.
    public func select (at index: Int, forceSetup: Bool = false) -> Promise<Void> {
        guard (0..<environments.count).contains(index) else {
            return Promise<Void>(error: EnvironmentError(code: .invalidEnvironmentIndex))
        }
        return select(identifier: environments[index].identifier, forceSetup: forceSetup)
    }

    /// Sets the internal selection to the environment, that matches the given
    /// identifier.
    ///
    /// If the currently selected environment matches the id and has been
    /// successfully set up, the exact same promise of this set up is returned.
    /// This avoids to repeat the setup unless `forceSetup` is set to true. When
    /// the setup fails the setup promise will be deleted, so on retry the setup
    /// will run again.
    public func select (identifier: String, forceSetup: Bool = false) -> Promise<Void> {
        if let selectedEnvironment = selectedEnvironment,
           selectedEnvironment.identifier == identifier,
           let setupPromise = setupPromise, !forceSetup {
            return setupPromise
        }

        setupPromise?.cancel()

        guard let environment = environments.first(where: { $0.identifier == identifier }) else {
            return Promise(error: EnvironmentError(code: .invalidEnvironmentIdentifier))
        }

        selectedEnvironment = environment
        delegate?.environmentManager(self, didSelectEnvironment: environment)

        setupPromise = executeTasks(of: environment)
            .then({
                self.delegate?.environmentManager(self, didSetupEnvironment: environment, withError: nil)
            })
            .catch({
                self.delegate?.environmentManager(self, didSetupEnvironment: environment, withError: $0)
                self.setupPromise = nil
            })
        return setupPromise!
    }

    /// Invokes the manager to execute all tasks provided by the given
    /// environment.
    ///
    /// Resets the internal index monitor and calls the recursive function
    /// `executeNextTask`.
    private func executeTasks (of environment: Environment) -> Promise<Void> {
        environmentSetupTasksIndex = 0
        return executeNextTask(for: environment)
    }

    /// Invokes the manager to execute the next task of the currently selected
    /// environment using an internal index property to monitor the index of the
    /// current setup task.
    private func executeNextTask (for environment: Environment) -> Promise<Void> {
        let index = environmentSetupTasksIndex
        guard index < environment.numberOfEnvironmentSetupTasks() else { return Promise() }

        let task = environment.environmentSetupTask(at: index)
        delegate?.environmentManager(self, willRunSetupTask: task, for: environment)
        return task.run(for: environment)
            .then({
                self.delegate?.environmentManager(self, didFinishSetupTask: task, withError: nil, for: environment)
                self.environmentSetupTasksIndex += 1
                return self.executeNextTask(for: environment)
            })
            .catch({
                let error = $0 is EnvironmentError ? $0 : EnvironmentError(code: .setupTaskFailed, previous: $0)
                self.delegate?.environmentManager(self, didFinishSetupTask: task, withError: error, for: environment)

                /* For converting the error for the promise child nodes */
                throw error
            })
    }


    public func configuration<T> (at path: String) -> T? {
        let sequence = path.split(separator: ".").map({ String($0) })
        return selectedEnvironment?.configuration(at: sequence)
    }
}


public extension EnvironmentManager {
    var numberOfEnvironments: Int { environments.count }

    func environmentIdentifier (at index: Int) -> String {
        environments[index].identifier
    }

    func environmentTitle (at index: Int) -> String? {
        environments[index].title
    }

    func environmentDescription (at index: Int) -> String? {
        environments[index].description
    }
}


public protocol EnvironmentManagerDelegate: class {
    func environmentManager(_ environmentManager: EnvironmentManager, didSelectEnvironment environment: Environment)
    func environmentManager(_ environmentManager: EnvironmentManager, didSetupEnvironment environment: Environment, withError error: Error?)

    func environmentManager(_ environmentManager: EnvironmentManager, willRunSetupTask task: EnvironmentSetupTask, for environment: Environment)
    func environmentManager(_ environmentManager: EnvironmentManager, didFinishSetupTask task: EnvironmentSetupTask, withError error: Error?, for environment: Environment)
}
