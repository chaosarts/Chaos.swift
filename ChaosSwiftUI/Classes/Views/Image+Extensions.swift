//
//  File.swift
//  
//
//  Created by fu.lam.diep on 30.09.22.
//

import SwiftUI

public extension Image {
    init(data: Data, placeholder: String, bundle: Bundle? = nil) {
        if let image = UIImage(data: data) {
            self.init(uiImage: image)
        } else {
            self.init(placeholder, bundle: bundle)
        }
    }
}
