#if canImport(UIKit)
//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

public extension UIView {

    convenience init(@UIViewBuilder _ build: () -> [UIViewBuilderMarkup]) {
        self.init()
        let markups = build()
        markups.forEach {
            self.addSubview($0.view)
        }

        NSLayoutConstraint.activate(layoutConstraints(for: markups))
    }

    func identifier(_ identifier: String) -> UIViewBuilderMarkup {
        UIViewBuilderMarkup(view: self, identifier: identifier, constraints: [])
    }

    func constraint(@LayoutConstraintBuilder _ build: () -> [LayoutConstraint]) -> UIViewBuilderMarkup {
        UIViewBuilderMarkup(view: self, constraints: build())
    }

    private func layoutConstraints(for markups: [UIViewBuilderMarkup]) -> [NSLayoutConstraint] {
        markups.flatMap { markup in
            markup.constraints.compactMap { layoutConstraint -> NSLayoutConstraint? in
                if let otherViewIdentifier = layoutConstraint.otherViewIdentifier {
                    guard let otherView = markups.first(withIdentifier: otherViewIdentifier)?.view else {
                        return nil
                    }
                    return NSLayoutConstraint(from: layoutConstraint, view: markup.view, otherView: otherView)
                }

                return NSLayoutConstraint(from: layoutConstraint, view: markup.view, otherView: self)
            }
        }
    }
}

#endif