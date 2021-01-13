//
//  EnvironmentManager.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import Foundation

private let kEnvironmentsUserDefaults = "Environments"
private let kSelectedEnvironmentUserDefaults = "SelectedEnvironment"

@objc
public final class EnvironmentManager: NSObject {

    public static let instance: EnvironmentManager = EnvironmentManager()

    public weak var dataSource: EnvironmentManagerDataSource?

    public weak var delegate: EnvironmentManagerDelegate?


    public func store (environments: [Environment]) {

    }

    @available(iOS 8, *)
    private func importEnvironments () -> [Environment] {
        guard let dataSource = dataSource else {
            fatalError("No data source set for environment manager.")
        }

        let bundle = dataSource.bundle(self)
        let name = dataSource.resourceName(self)
        let ext = dataSource.resourceExtension(self)

        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            fatalError("Resource '\(name)' not found in bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            return dataSource.environmentManager(self, decodeEnvironmentFrom: data)
        } catch {
            fatalError("Unable to load environments from file: \(error)")
        }
    }
}


public extension EnvironmentManager {
}

public protocol EnvironmentManagerDataSource: class {
    func bundle (_ environmentManager: EnvironmentManager) -> Bundle
    func resourceName (_ environmentManager: EnvironmentManager) -> String
    func resourceExtension (_ environmentManager: EnvironmentManager) -> String?
    func environmentManager (_ environmentManager: EnvironmentManager, decodeEnvironmentFrom data: Data) -> [Environment]
    func environmentManager (_ environmentManager: EnvironmentManager, encodeEnvironment environment: Environment) -> Data
}

public extension EnvironmentManagerDataSource {
    func bundle (_ environmentManager: EnvironmentManager) -> Bundle { return .main }
    func resourceName (_ environmentManager: EnvironmentManager) -> String { return "environment" }
    func resourceExtension (_ environmentManager: EnvironmentManager) -> String { return "json" }
}

public protocol EnvironmentManagerDelegate: class {
    func environmentManager(_ environmentManager: EnvironmentManager, didSelectEnvironment environment: Environment)
    func environmentManager(_ environmentManager: EnvironmentManager, didSetupEnvironment environment: Environment, withError error: Error?)

    func environmentManager(_ environmentManager: EnvironmentManager, willRunSetupTask task: EnvironmentSetupTask, for environment: Environment)
    func environmentManager(_ environmentManager: EnvironmentManager, didFinishSetupTask task: EnvironmentSetupTask, withError error: Error?, for environment: Environment)
}
