//
//  RestDataDecoder.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

/// Specifies the protocol for an rest data decoder. An api data decoder is
/// specified when creating an api client. It used, when the client receives
/// response data from the transport engine.
///
/// To use a actual implementation, one can create a extension of exisiting
/// decoder, such as `JSONDecoder`.
public protocol RestDataDecoder {

    /// Specifies the mime type to expect from the api. The according header of an
    /// api request will automatically set to this mime type.
    var mimeType: MimeType { get }

    /// Decodes the given data to the sepcified decodable data type.
    func decode<D: Decodable> (_ decodable: D.Type, from data: Data) throws -> D
}
