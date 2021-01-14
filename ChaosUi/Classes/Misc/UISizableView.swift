//
//  UIStackViewItem.swift
//  Chaos
//
//  Created by Fu Lam Diep on 03.11.20.
//

import UIKit

open class UISizableView: UIView {

    open var intrinsicWidth: CGFloat? {
        didSet { invalidateIntrinsicContentSize() }
    }

    open var intrinsicHeight: CGFloat?  {
        didSet { invalidateIntrinsicContentSize() }
    }

    open override var intrinsicContentSize: CGSize {
        CGSize(width: intrinsicWidth ?? super.intrinsicContentSize.width,
               height: intrinsicHeight ?? super.intrinsicContentSize.height)
    }
}
