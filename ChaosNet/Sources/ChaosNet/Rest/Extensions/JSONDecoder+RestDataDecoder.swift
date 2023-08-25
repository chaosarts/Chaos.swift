//
//  JSONDecoder+RestDataDecoder.swift
//  ChaosAnimation-iOS
//
//  Created by Fu Lam Diep on 30.12.21.
//

import Foundation

extension JSONDecoder: RestDataDecoder {
    public var mimeType: MimeType { .application("json") }
}
