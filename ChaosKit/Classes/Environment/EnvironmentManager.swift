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
    public var fileImportDecoder: EnvironmentDataDecoder = JSONDecoder()

    /// Provides the list of environments.
    private var environments: [Environment] = []

    /// Provides the id of tha last selected environment.
    private var lastSelectedEnvironmentId: String? {
        get { UserDefaults.environmentManager.string(forKey: kSelectedEnvironmentUserDefaults) }
        set { UserDefaults.environmentManager.setValue(newValue, forKey: kSelectedEnvironmentUserDefaults) }
    }

    /// Provides the currently selected envrionment
    private var selectedEnvironment: Environment! {
        didSet {  lastSelectedEnvironmentId = selectedEnvironment.identifier }
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

    /// Provides the list of setup tasks of the currently selected environment
    private var environmentSetupTasks: [EnvironmentSetupTask] = []

    /// Provides a promise that resolves, when the selected environment is
    /// completely setup.
    private var setupPromise: Promise<Void>!


    // MARK: Initialization

    private override init () {}


    // MARK: Managing Environments

    /// Loads the environment configurations from disk and imports into the
    /// application storage (UserDefaults) and loads into the internal storage.
    public func loadEnvrionments<E: Environment> (type: E.Type, filename: String = "environments", bundle: Bundle = .main) throws {
        do {
            if #available(iOS 8, *) {
                let environments = try environmentsFromFile(type: type)
                try storeEnvironments(environments)
            }

            guard let data = UserDefaults.environmentManager.data(forKey: kEnvironmentsUserDefaults) else {
                throw EnvironmentError(code: .noUserDefaultsEntryFound)
            }

            environments = try PropertyListDecoder().decode([E].self, from: data)
        } catch {
            throw EnvironmentError(code: .loadingEnvironmentsFailed, previous: error)
        }
    }

    /// Reads and decode the environment configurations from a file and stores
    /// them to the user defaults.
    @available(iOS 8, *)
    public func environmentsFromFile<E: Environment> (type: E.Type, filename: String = "environments", bundle: Bundle = .main) throws -> [E] {
        guard let url = bundle.url(forResource: filename, withExtension: fileImportDecoder.fileExtension) else {
            throw EnvironmentError(code: .environmentsFileNotFound)
        }

        let data = try Data(contentsOf: url)
        return try fileImportDecoder.decode([E].self, from: data)
    }

    /// Stores the list of environments in the user defaults.
    private func storeEnvironments<E: Environment> (_ environments: [E]) throws {
        let data = try PropertyListEncoder().encode(environments)
        UserDefaults.environmentManager.setValue(data, forKey: kEnvironmentsUserDefaults)
    }


    // MARK: Environment Selection and Setup

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


    public func select (at index: Int, forceSetup: Bool = false) -> Promise<Void> {
        guard (0..<environments.count).contains(index) else {
            return Promise<Void>(error: EnvironmentError(code: .invalidEnvironmentIndex))
        }
        return select(identifier: environments[index].identifier)
    }

    public func select (identifier: String, forceSetup: Bool = false) -> Promise<Void> {
        if let selectedEnvironment = selectedEnvironment,
           selectedEnvironment.identifier == identifier,
           let setupPromise = setupPromise, !forceSetup {
            return setupPromise
        }

        setupPromise?.cancel()
        environmentSetupTasks = []

        guard let environment = environments.first(where: { $0.identifier == identifier }) else {
            return Promise(error: EnvironmentError(code: .invalidEnvironmentIdentifier))
        }

        selectedEnvironment = environment
        delegate?.environmentManager(self, didSelectEnvironment: environment)
        
        for index in 0..<environment.numberOfEnvironmentSetupTasks() {
            environmentSetupTasks.append(environment.environmentSetupTask(at: index))
        }

        setupPromise = executeNextSetupTask()
            .catch({ throw EnvironmentError(code: .setupFailed, previous: $0) })
            .then({ self.delegate?.environmentManager(self, didSetupEnvironment: environment, withError: nil) })
            .catch({ self.delegate?.environmentManager(self, didSetupEnvironment: environment, withError: $0) })

        return setupPromise
    }

    private func executeNextSetupTask () -> Promise<Void> {
        if environmentSetupTasks.count > 0 {
            let nextTask = environmentSetupTasks.removeFirst()
            delegate?.environmentmanager(self, willRunSetupTask: nextTask)
            return nextTask.run()
                .then({ self.delegate?.environmentmanager(self, didFinishSetupTask: nextTask, withError: nil) })
                .catch({ self.delegate?.environmentmanager(self, didFinishSetupTask: nextTask, withError: $0) })
                .then(executeNextSetupTask)
        }

        let void: Void
        return Promise(value: void)
    }


    public func configuration<T> (at path: String) -> T? {
        let sequence = path.split(separator: ".").map({ String($0) })
        return selectedEnvironment.configuration(at: sequence)
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
    func environmentmanager(_ environmentManager: EnvironmentManager, willRunSetupTask task: EnvironmentSetupTask)
    func environmentmanager(_ environmentManager: EnvironmentManager, didFinishSetupTask task: EnvironmentSetupTask, withError error: Error?)
    func environmentManager(_ environmentManager: EnvironmentManager, didSetupEnvironment environment: Environment, withError error: Error?)
}
