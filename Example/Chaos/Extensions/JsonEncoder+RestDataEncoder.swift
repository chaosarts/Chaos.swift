//
//  JsonEncoder+RestDataEncoder.swift
//  Webservice
//
//  Created by Fu Lam Diep on 01.09.21.
//

import Foundation
import ChaosNet

extension JSONDecoder: RestDataDecoder {
    public var mimeType: MimeType { .text("json") }
}
