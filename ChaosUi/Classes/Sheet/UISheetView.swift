//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 13.01.21.
//

import UIKit

open class UISheetView: UIView {

    @objc public dynamic var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    public convenience init () {
        self.init(frame: .zero)
        prepare()
    }

    private func prepare () {

    }
}

@objc
public protocol UISheetDelegate: class {

}
