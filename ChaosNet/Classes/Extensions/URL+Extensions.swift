//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 14.01.22.
//

import Foundation

public extension URL {
    func components(resolvingAgainstBaseURL: Bool) -> URLComponents? {
        URLComponents(url: self, resolvingAgainstBaseURL: resolvingAgainstBaseURL)
    }
}
