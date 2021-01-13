//
//  String+Transform.swift
//  Chaos
//
//  Created by Fu Lam Diep on 16.11.20.
//

import Foundation

public extension String {

    func ucfirst () -> String {
        var string = self
        guard string.count > 0 else { return self }
        let firstCharacter = String(string.removeFirst())
        return firstCharacter.uppercased() + string
    }

    func lcfirst () -> String {
        var string = self
        guard string.count > 0 else { return self }
        let firstCharacter = String(string.removeFirst())
        return firstCharacter.lowercased() + string
    }

    func snakecased () -> String {
        do {
            let regex = try NSRegularExpression(pattern: "([a-z0-9])([A-Z])", options: [])
            let string = NSMutableString(string: self)
            regex.replaceMatches(in: string, options: [], range: NSRange(0..<self.count), withTemplate: "$1_$2")
            return String(string).lowercased()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
