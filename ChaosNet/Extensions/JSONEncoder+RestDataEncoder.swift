//
//  JSONEncoder+RestDataEncoder.swift
//  Pods
//
//  Created by Fu Lam Diep on 30.12.21.
//

import Foundation

extension JSONEncoder: RestDataEncoder {
    public var mimeType: MimeType { .application("json") }
}
