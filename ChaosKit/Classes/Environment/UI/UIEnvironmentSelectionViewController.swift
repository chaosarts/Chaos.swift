//
//  UIEnvironmentSelection.swift
//  ChaosKit
//
//  Created by Fu Lam Diep on 19.10.20.
//

import UIKit

@objc
public protocol UIEnvironmentSelectionViewControllerDelegate: class, NSObjectProtocol {

    /// Tells the delegate, that the environment selection view controller did
    /// select the environment at the given index.
    ///
    /// This does not invoke the environment manager to select and setup the
    /// corresponding environment. It is up to you to implement that part. This
    /// gives you the freedom to first dismiss the selection view controller,
    /// before you start setting up the environment.
    func environmentSelection (_ environmentSelection: UIEnvironmentSelectionViewController, didSelectEnvironmentAt index: Int)
}

open class UIEnvironmentSelectionViewController: UITableViewController {

    // MARK: Properties

    /// Provides the environment singleton that serves as the indirect data
    /// source.
    public let environmentManager: EnvironmentManager = .instance

    /// Provides the prefix string to prepend to the id to build the icon
    /// image name.
    public var environmentImagePrefix: String = "envlogo-"

    /// Provides the suffix string to append to the id to build the icon
    /// image name.
    public var environmentImageSuffix: String = ""

    /// Provides the delegate object to tell about selection made.
    public weak var delegate: UIEnvironmentSelectionViewControllerDelegate?


    // MARK: UIViewController Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
    }


    // MARK: UITableViewDataSource Implementation

    public final override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        environmentManager.numberOfEnvironments
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let environmentIdentifier = environmentManager.environmentIdentifier(at: indexPath.row)
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: environmentIdentifier) ??
            tableView.dequeueReusableCell(withIdentifier: "Default") ??
            UITableViewCell(style: .subtitle, reuseIdentifier: "Default")

        let index = indexPath.row
        let identifier = environmentManager.environmentIdentifier(at: indexPath.row)
        let title = environmentManager.environmentTitle(at: indexPath.row)
        let description = environmentManager.environmentDescription(at: indexPath.row)
        let image = UIImage(named: "\(environmentImagePrefix)\(identifier)\(environmentImageSuffix)")

        tableViewCell.textLabel?.text = title ?? identifier
        tableViewCell.detailTextLabel?.text = description
        tableViewCell.imageView?.image = image

        if environmentManager.selectedEnvironmentIndex == indexPath.row {
            tableViewCell.accessoryType = .checkmark
        } else {
            tableViewCell.accessoryType = .none
        }

        return tableViewCell
    }


    // MARK: UITableViewDelegate Implementation

    public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        delegate?.environmentSelection(self, didSelectEnvironmentAt: indexPath.row)
    }
}
