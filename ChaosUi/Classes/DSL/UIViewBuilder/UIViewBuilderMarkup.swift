//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

public struct UIViewBuilderMarkup {

    public let view: UIView

    public private(set) var identifier: String?
    
    public let constraints: [LayoutConstraint]

    public func identifier(_ identifier: String) -> UIViewBuilderMarkup {
        UIViewBuilderMarkup(view: view, identifier: identifier, constraints: constraints)
    }
}


public extension Array where Element == UIViewBuilderMarkup {
    func first(withIdentifier identifier: String) -> UIViewBuilderMarkup? {
        first { $0.identifier == identifier }
    }
}
