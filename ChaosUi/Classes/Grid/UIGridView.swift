//
//  UIGridView.swift
//  Chaos
//
//  Created by Fu Lam Diep on 08.11.20.
//

import Foundation

@objc open class UIGridView: UIView {


}

public extension UIGridView {
    @objc public class Position: NSObject {
        public let row: Int
        public let col: Int

        public init (row: Int, col: Int) {
            self.row = row
            self.col = col
        }
    }
}

@objc open class UIGridViewCell: UIView {

}


@objc public protocol UIGridViewDataSource: class, NSObjectProtocol {
    @objc func numberOfRows (_ gridView: UIGridView) -> Int
    @objc func numberOfColumns (_ gridView: UIGridView) -> Int
    @objc func gridView (_ gridView: UIGridView, cellForItemAt position: UIGridView.Position) -> UIGridViewCell

    @objc optional func gridView (_ gridView: UIGridView, rowspanForItemAt position: UIGridView.Position) -> Int
    @objc optional func gridView (_ gridView: UIGridView, colspanForItemAt position: UIGridView.Position) -> Int
}
