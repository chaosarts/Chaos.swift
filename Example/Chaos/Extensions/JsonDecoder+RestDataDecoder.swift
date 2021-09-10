//
//  JsonDecoder+RestDataDecoder.swift
//  Webservice
//
//  Created by Fu Lam Diep on 01.09.21.
//

import Foundation
import ChaosNet

extension JSONEncoder: RestDataEncoder {
    public var mimeType: MimeType { .text("json") }
}
