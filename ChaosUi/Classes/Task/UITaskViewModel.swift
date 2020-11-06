//
//  UITaskViewModel.swift
//  ChaosUi
//
//  Created by Fu Lam Diep on 26.10.20.
//

import Foundation

@objc
public class UITaskViewModel: NSObject {

    internal let task: Task

    public var id: String { task.id }

    public var title: String?

    public var detailText: String?

    public var image: UIImage?

    public init (task: Task, title: String? = nil, detailText: String? = nil, image: UIImage? = nil) {
        self.task = task
        self.title = title
        self.detailText = detailText
        self.image = image
    }
}
