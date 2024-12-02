//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import Foundation

extension String.Encoding {
    public var htmlCharacterSet: String {
        switch self {
        case String.Encoding.ascii:
            "US-ASCII"
        case String.Encoding.nextstep:
            "nextstep"
        case String.Encoding.japaneseEUC:
            "EUC-JP"
        case String.Encoding.utf8:
            "UTF-8"
        case String.Encoding.isoLatin1:
            "csISOLatin1"
        case String.Encoding.symbol:
            "MacSymbol"
        case String.Encoding.nonLossyASCII:
            "nonLossyASCII"
        case String.Encoding.shiftJIS:
            "shiftJIS"
        case String.Encoding.isoLatin2:
            "csISOLatin2"
        case String.Encoding.unicode:
            "unicode"
        case String.Encoding.windowsCP1251:
            "windows-1251"
        case String.Encoding.windowsCP1252:
            "windows-1252"
        case String.Encoding.windowsCP1253:
            "windows-1253"
        case String.Encoding.windowsCP1254:
            "windows-1254"
        case String.Encoding.windowsCP1250:
            "windows-1250"
        case String.Encoding.iso2022JP:
            "iso2022jp"
        case String.Encoding.macOSRoman:
            "macOSRoman"
        case String.Encoding.utf16:
            "UTF-16"
        case String.Encoding.utf16BigEndian:
            "UTF-16BE"
        case String.Encoding.utf16LittleEndian:
            "UTF-16LE"
        case String.Encoding.utf32:
            "UTF-32"
        case String.Encoding.utf32BigEndian:
            "UTF-32BE"
        case String.Encoding.utf32LittleEndian:
            "UTF-32LE"
        default:
            self.description
        }
    }
}
