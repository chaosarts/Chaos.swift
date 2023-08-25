//
//  File.swift
//
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, @UIViewBuilder _ build: () -> [UIViewBuilderMarkup]) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        let markups = build()
        markups.forEach {
            self.addArrangedSubview($0.view)
        }
    }
}
