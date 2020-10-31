//
//  main.swift
//  ChaosCliExample
//
//  Created by Fu Lam Diep on 29.10.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

func main () {

    do {
        let string = "application/json"
        let pattern = "^\\s*([^/]+)/([^;]+)\\s*(;\\s*([^=]+)\\s*=\\s*([^\\s]*))?\\s*$"
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: string.count)

        let matches = regex.matches(in: string, options: [], range: range).map({ match -> [String] in
            var output: [String] = []
            for i in 0..<match.numberOfRanges {
                let matchedRange = match.range(at: i)
                guard matchedRange.length > 0 else { continue }
                let startIndex = string.index(string.startIndex, offsetBy: matchedRange.lowerBound)
                let endIndex = string.index(startIndex, offsetBy: matchedRange.length)
                output.append(String(string[startIndex..<endIndex]))
            }
            return output
        })
        print(matches)
    } catch {
        print(error)
    }
}

main()
