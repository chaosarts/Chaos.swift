#if canImport(UIKit)
//
//  UIAlertAction+Defaults.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import UIKit

public extension UIAlertAction {
    static func ok (style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let title = Bundle(identifier: "com.apple.UIKit")?
            .localizedString(forKey: "OK", value: "OK", table: nil) ?? "OK"
        return UIAlertAction(title: title, style: style, handler: handler)
    }

    static func cancel (style: UIAlertAction.Style = .cancel, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let title = Bundle(identifier: "com.apple.UIKit")?
            .localizedString(forKey: "Cancel", value: "Cancel", table: nil) ?? "Cancel"
        return UIAlertAction(title: title, style: style, handler: handler)
    }

    static func destructive (title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .destructive, handler: handler)
    }
}

#endif