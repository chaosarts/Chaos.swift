//
//  String+NSRegularExpression.swift
//  ChaosCore
//
//  Created by Fu Lam Diep on 29.10.20.
//

import Foundation

public extension String {

    func extract (withRegExp regex: NSRegularExpression) -> [[String]] {
        let range = NSRange(location: 0, length: self.count)

        let matches = regex.matches(in: self, options: [], range: range).map({ match -> [String] in
            var output: [String] = []
            for i in 0..<match.numberOfRanges {
                let matchedRange = match.range(at: i)
                guard matchedRange.length > 0 else { continue }
                let startIndex = index(self.startIndex, offsetBy: matchedRange.lowerBound)
                let endIndex = index(startIndex, offsetBy: matchedRange.length)
                output.append(String(self[startIndex..<endIndex]))
            }
            return output
        })

        return matches
    }


    func extract (withPattern pattern: String, options: NSRegularExpression.Options = []) throws -> [[String]] {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        return extract(withRegExp: regex)
    }
}
