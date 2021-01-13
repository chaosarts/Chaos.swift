//
//  MimeTypeTests.swift
//  Chaos_Tests
//
//  Created by Fu Lam Diep on 12.11.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import Chaos

public class MimeTypeTests: XCTestCase {

    public func testRealMimeTypes () {
        for mimeTypeString in mimeTypeStrings {
            XCTAssertNotNil(MimeType(mimeTypeString))
        }
    }

    public func testStringInitialization () {
        var mimeType = MimeType("app/domain")
        XCTAssertNotNil(mimeType)
        XCTAssertEqual(mimeType?.domain, "app")
        XCTAssertEqual(mimeType?.subtype, "domain")

        mimeType = MimeType("app/domain")
        XCTAssertNotNil(mimeType)

        XCTAssertNil(MimeType("abc%/jshdf"))
        XCTAssertNil(MimeType("abc/?jshdf"))
    }

    public func testStaticInitializers () {
        var mimeType: MimeType
        mimeType = .application("json")
        XCTAssertEqual(mimeType.domain, "application")
        XCTAssertEqual(mimeType.subtype, "json")

        XCTAssertEqual(MimeType(domain: "application", subtype: "json"), MimeType("application/json"))
    }
}

public extension MimeTypeTests {
    var mimeTypeStrings: [String] {
        ["application/acad", "application/applefile",
         "application/astound", "application/dsptype",
         "application/dxf", "application/force-download",
         "application/futuresplash", "application/gzip",
         "application/javascript", "application/json",
         "application/listenup", "application/mac-binhex40",
         "application/mbedlet", "application/mif",
         "application/msexcel", "application/mshelp",
         "application/mspowerpoint", "application/msword",
         "application/octet-stream", "application/oda",
         "application/pdf", "application/postscript",
         "application/rtc", "application/rtf",
         "application/studiom", "application/toolbook",
         "application/vocaltec-media-desc", "application/vocaltec-media-file",
         "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
         "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
         "application/xhtml+xml", "application/xml",
         "application/x-bcpio", "application/x-compress",
         "application/x-cpio", "application/x-csh",
         "application/x-director", "application/x-dvi",
         "application/x-envoy", "application/x-gtar",
         "application/x-hdf", "application/x-httpd-php",
         "application/x-latex", "application/x-macbinary",
         "application/x-mif", "application/x-netcdf",
         "application/x-nschat", "application/x-sh",
         "application/x-shar", "application/x-shockwave-flash",
         "application/x-sprite", "application/x-stuffit",
         "application/x-supercard", "application/x-sv4cpio",
         "application/x-sv4crc", "application/x-tar",
         "application/x-tcl", "application/x-tex",
         "application/x-texinfo", "application/x-troff",
         "application/x-troff-man", "application/x-troff-me",
         "application/x-troff-ms", "application/x-ustar",
         "application/x-wais-source", "application/x-www-form-urlencoded",
         "application/zip", "audio/basic",
         "audio/echospeech", "audio/mpeg",
         "audio/mp4", "audio/ogg",
         "audio/tsplayer", "audio/voxware",
         "audio/wav", "audio/x-aiff",
         "audio/x-dspeeh", "audio/x-midi",
         "audio/x-mpeg", "audio/x-pn-realaudio",
         "audio/x-pn-realaudio-plugin", "audio/x-qt-stream",
         "drawing/x-dwf", "image/bmp",
         "image/x-bmp", "image/x-ms-bmp",
         "image/cis-cod", "image/cmu-raster",
         "image/fif", "image/gif",
         "image/ief", "image/jpeg",
         "image/png", "image/svg+xml",
         "image/tiff", "image/vasa",
         "image/vnd.wap.wbmp", "image/x-freehand",
         "image/x-icon", "image/x-portable-anymap",
         "image/x-portable-bitmap", "image/x-portable-graymap",
         "image/x-portable-pixmap", "image/x-rgb",
         "image/x-windowdump", "image/x-xbitmap",
         "image/x-xpixmap", "message/external-body",
         "message/http", "message/news",
         "message/partial", "message/rfc822",
         "model/vrml", "multipart/alternative",
         "multipart/byteranges", "multipart/digest",
         "multipart/encrypted", "multipart/form-data",
         "multipart/mixed", "multipart/parallel",
         "multipart/related", "multipart/report",
         "multipart/signed", "multipart/voice-message",
         "text/calendar", "text/comma-separated-values",
         "text/css", "text/html",
         "text/javascript", "text/plain",
         "text/richtext", "text/rtf",
         "text/tab-separated-values", "text/vnd.wap.wml",
         "application/vnd.wap.wmlc", "text/vnd.wap.wmlscript",
         "application/vnd.wap.wmlscriptc", "text/xml",
         "text/xml-external-parsed-entity", "text/x-setext",
         "text/x-sgml", "text/x-speech",
         "video/mpeg", "video/mp4",
         "video/ogg", "video/quicktime",
         "video/vnd.vivo", "video/webm",
         "video/x-msvideo", "video/x-sgi-movie",
         "video/3gpp", "workbook/formulaone", "x-world/x-3dmf", "x-world/x-vrml"]
    }
}
