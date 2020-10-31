//
//  RestDataDecoder.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation

/// Specifies the protocol for an api data decoder. An api data decoder is
/// specified when creating an api client. It used, when the client receives
/// response data from the transport engine.
///
/// To use a actual implementation, one can create a extension of exisiting
/// decoder, such as `JSONDecoder`.
public protocol ApiDataDecoder {

    /// Specifies the mime type to expect from the api. The according header of an
    /// api request will automatically set to this mime type.
    var mimeType: MimeType { get }

    /// Decodes the given data to the sepcified decodable data type.
    func decode<D: Decodable> (_ decodable: D.Type, from data: Data) throws -> D
}
