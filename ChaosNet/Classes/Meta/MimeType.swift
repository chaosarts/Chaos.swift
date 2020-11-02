//
//  MimeType.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation
import ChaosCore

public struct MimeType {

    /// Provides the main type (e.g. application, text) as string.
    public let domain: String

    /// Provides the subtype (e.g. json, html, mp3) of the mime type.
    public let subtype: String

    /// Provides an optional parameter of the mime type (e.g. charset=utf-8)
    public let parameter: Parameter?

    /// Provides the string representation of the mime type
    public var description: String {
        var desc = "\(domain)/\(subtype)"
        if let parameter = parameter { desc += "; \(parameter)" }
        return desc
    }

    // MARK: Initialization

    /// Initializes the mime type, with an arbitrary domain, subtype and
    /// parameter. `domain` and `subtype` will be trimmed by whitespaces.
    public init (domain: String, subtype: String, parameter: Parameter? = nil) {
        self.domain = domain.trimmingCharacters(in: .whitespaces)
        self.subtype = subtype.trimmingCharacters(in: .whitespaces)
        self.parameter = parameter
    }

    /// Attempts initializes the mime type with a string representation, including
    /// parameter. If the string does not conform the initialization will fail.
    public init? (_ string: String) {
        do {
            let pattern = "^\\s*([^/]+)/([^;]+)\\s*(;\\s*([^=]+)\\s*=\\s*([^\\s]*))?\\s*$"
            let matches = try string.extract(withPattern: pattern)
            guard matches.count > 0, matches[0].count > 2 else { return nil }

            let domain = matches[0][1]
            let subtype = matches[0][2]
            var parameter: Parameter? = nil
            if (matches[0].count == 6) {
                parameter = Parameter(key: matches[0][4], value: matches[0][5])
            }
            self.init(domain: domain, subtype: subtype, parameter: parameter)
        } catch {
            print(error)
            return nil
        }
    }


    // MARK: Convenient Methods

    /// Convenient method to create a mime type of the 'application/`subtype`'
    /// domain.
    public static func application (_ subtype: String, parameter: Parameter? = nil) -> MimeType {
        MimeType(domain: "application", subtype: subtype, parameter: parameter)
    }

    /// Convenient method to create a mime type of the 'audio/`subtype`' domain.
    public static func audio (_ subtype: String) -> MimeType {
        MimeType(domain: "audio", subtype: subtype, parameter: nil)
    }

    /// Convenient method to create a mime type of the 'image/`subtype`' domain.
    public static func image (_ subtype: String) -> MimeType {
        MimeType(domain: "image", subtype: subtype)
    }

    /// Convenient method to create a mime type of the 'message/`subtype`' domain.
    public static func message(_ subtype: String) -> MimeType {
        MimeType(domain: "message", subtype: subtype)
    }

    /// Convenient method to create a mime type of the 'model/`subtype`' domain.
    public static func model(_ subtype: String) -> MimeType {
        MimeType(domain: "model", subtype: subtype)
    }

    /// Convenient method to create a mime type of the 'multipart/`subtype`'
    /// domain.
    public static func multipart(_ subtype: String, boundary: String? = nil) -> MimeType {
        var parameter: Parameter? = nil
        if let boundary = boundary { parameter = .boundary(boundary) }
        return MimeType(domain: "multipart", subtype: subtype, parameter: parameter)
    }

    /// Convenient method to create a mime type of the 'text/`subtype`'
    /// domain.
    public static func text(_ subtype: String, charset: String.Encoding? = nil) -> MimeType {
        var parameter: Parameter? = nil
        if let charset = charset { parameter = .charset(charset) }
        return MimeType(domain: "text", subtype: subtype, parameter: parameter)
    }

    /// Convenient method to create a mime type of the 'video/`subtype`'
    /// domain.
    public static func video(_ subtype: String) -> MimeType {
        return MimeType(domain: "video", subtype: subtype)
    }
}

public extension MimeType {

    /// Class to represent a mime type parameter such as 'boundary=abc'
    public class Parameter: NSObject {

        /// Provides the key or name of this parameter
        public let key: String

        /// Provides the value of this parameter
        public let value: String

        /// Provides the string representation of this parameter
        public override var description: String { "\(key)=\(value)" }

        /// Initializes the parameter with given key and value.
        fileprivate init (key: String, value: String) {
            self.key = key
            self.value = value
        }


        // MARK: Convenient Static Methods

        /// Returns a charset parameter with given encoding
        public static func charset (_ encoding: String.Encoding) -> Parameter {
            Parameter(key: "charset", value: encoding.description)
        }

        /// Returns a boundary parameter with given boundary value.
        public static func boundary (_ boundary: String) -> Parameter {
            Parameter(key: "boundary", value: boundary)
        }
    }
}
