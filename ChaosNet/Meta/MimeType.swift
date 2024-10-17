//
//  MimeType.swift
//  ChaosNet
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation
import ChaosCore

public struct MimeType: Equatable {

    /// Provides the main type (e.g. application, text) as string.
    public let domain: String

    /// Provides the subtype (e.g. json, html, mp3) of the mime type.
    public let subtype: String

    /// Provides the string representation of the mime type
    public var description: String {
        let desc = "\(domain)/\(subtype)"
        return desc
    }

    // MARK: Initialization

    /// Initializes the mime type, with an arbitrary domain, subtype and
    /// parameter. `domain` and `subtype` will be trimmed by whitespaces.
    public init (domain: String, subtype: String) {
        self.domain = domain.trimmingCharacters(in: .whitespaces)
        self.subtype = subtype.trimmingCharacters(in: .whitespaces)
    }

    /// Attempts initializes the mime type with a string representation, including
    /// parameter. If the string does not conform the initialization will fail.
    public init? (_ string: String) {
        do {
            let pattern = "\\s*([\\w\\-]+)/([\\w\\d\\-\\.\\*\\+]+)"
            let matches = try string.extract(withPattern: pattern)
            guard matches.count > 0, matches[0].count > 2 else { return nil }

            let domain = matches[0][1]
            let subtype = matches[0][2]
            self.init(domain: domain, subtype: subtype)
        } catch {
            print(error)
            return nil
        }
    }


    public static func == (lhs: MimeType, rhs: MimeType) -> Bool {
        return lhs.domain.lowercased() == rhs.domain.lowercased() &&
            lhs.subtype.lowercased() == rhs.subtype.lowercased()
    }


    // MARK: Convenient Methods

    /// Convenient method to create a mime type of the 'application/`subtype`'
    /// domain.
    public static func application (_ subtype: String) -> MimeType {
        MimeType(domain: "application", subtype: subtype)
    }

    /// Convenient method to create a mime type of the 'audio/`subtype`' domain.
    public static func audio (_ subtype: String) -> MimeType {
        MimeType(domain: "audio", subtype: subtype)
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
    public static func multipart(_ subtype: String) -> MimeType {
        return MimeType(domain: "multipart", subtype: subtype)
    }

    /// Convenient method to create a mime type of the 'text/`subtype`'
    /// domain.
    public static func text(_ subtype: String) -> MimeType {
        return MimeType(domain: "text", subtype: subtype)
    }

    /// Convenient method to create a mime type of the 'video/`subtype`'
    /// domain.
    public static func video(_ subtype: String) -> MimeType {
        return MimeType(domain: "video", subtype: subtype)
    }
}
