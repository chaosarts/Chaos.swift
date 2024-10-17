#if canImport(UIKit)
//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.21.
//
import UIKit

open class UICardView: UIView {

    @objc open override dynamic var backgroundColor: UIColor? {
        get { content.backgroundColor }
        set { content.backgroundColor = newValue }
    }

    @objc open dynamic var cornerRadius: CGFloat {
        get { content.layer.cornerRadius }
        set { content.layer.cornerRadius = newValue }
    }

    private let content: UIView = UIView()

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
        cornerRadius = 14.0
        content.translatesAutoresizingMaskIntoConstraints = false
        content.layer.masksToBounds = true

        addSubview(content)
        addConstraints(content.constraintsToSuperviewEdges())
    }
}


#endif