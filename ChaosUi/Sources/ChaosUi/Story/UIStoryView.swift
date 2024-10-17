#if canImport(UIKit)
//
//  UIStoryView.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 17.03.21.
//

import UIKit

open class UIStoryView: UIView {

    open var headerView: UIView?
}


@objc public protocol UIStoryViewDataSource: AnyObject {

}

#endif