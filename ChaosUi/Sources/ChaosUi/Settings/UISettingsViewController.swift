//
//  UISettingsViewController.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 30.06.21.
//

import UIKit

open class UISettingsView: UIView {

    // MARK: Abstraction Properties

    open weak var dataSource: UISettingsViewDataSource?

    open weak var delegate: UISettingsViewDelegate?


    // MARK: Subviews

    private var tableView: UITableView = UITableView()


    // MARK: Initialization

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    private func prepare () {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        addConstraints([
            topAnchor.constraint(equalTo: tableView.topAnchor),
            rightAnchor.constraint(equalTo: tableView.rightAnchor),
            bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            leftAnchor.constraint(equalTo: tableView.leftAnchor)
        ])
    }

    
    // MARK: Control Data

    public func reloadData () {
        tableView.reloadData()
    }
}

extension UISettingsView: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.numberOfSection?(self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.settingsView(self, numberOfSettingsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "SettingsViewCell", for: indexPath)
    }
}

@objc public protocol UISettingsViewDataSource: AnyObject {
    @objc optional func numberOfSection (_ view: UISettingsView) -> Int
    @objc func settingsView (_ view: UISettingsView, numberOfSettingsInSection section: Int) -> Int
}

@objc public protocol UISettingsViewDelegate: AnyObject {
    @objc optional func settingsView (_ view: UISettingsView, didChangeValueAt indexPath: IndexPath)
}
