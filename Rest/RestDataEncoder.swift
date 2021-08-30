//
//  RestDataEncoder.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 18.08.21.
//

import Foundation

/// Specifies the protocol for an REST data encoder. An api data encoder is set in
/// the api client and used by the action builder to encode encodable objects.
///
/// To use a actual implementation, one can create a extension of exisiting
/// encoder, such as `JSONEncoder`.
public protocol RestDataEncoder {

    /// Sepcifies the mime type to set in the header, when sending an api request
    /// with payload.
    var mimeType: MimeType { get }

    /// Encodes the given object into a data object, which can then be used as
    /// payload data for the api request.
    func encode<E: Encodable>(_ type: E) throws -> Data
}
