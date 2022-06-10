//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 03.06.22.
//

import UIKit

public extension KeyPath where Root == UIView, Value == NSLayoutXAxisAnchor {
    var layoutAttribute: NSLayoutConstraint.Attribute? {
        if self == \UIView.leadingAnchor {
            return .leading
        } else if self == \UIView.centerXAnchor {
            return .centerX
        } else if self == \UIView.trailingAnchor {
            return .trailing
        } else if self == \UIView.leftAnchor {
            return .left
        } else if self == \UIView.rightAnchor {
            return .right
        } else {
            return nil
        }
    }
}

public extension KeyPath where Root == UIView, Value == NSLayoutYAxisAnchor {
    var layoutAttribute: NSLayoutConstraint.Attribute? {
        if self == \UIView.topAnchor {
            return .top
        } else if self == \UIView.centerYAnchor {
            return .centerY
        } else if self == \UIView.bottomAnchor {
            return .bottom
        } else if self == \UIView.lastBaselineAnchor {
            return .lastBaseline
        } else if self == \UIView.firstBaselineAnchor {
            return .firstBaseline
        } else {
            return nil
        }
    }
}

public extension KeyPath where Root == UIView, Value == NSLayoutDimension {
    var layoutAttribute: NSLayoutConstraint.Attribute? {
        if self == \UIView.widthAnchor {
            return .width
        } else if self == \UIView.heightAnchor {
            return .height
        } else {
            return nil
        }
    }
}
