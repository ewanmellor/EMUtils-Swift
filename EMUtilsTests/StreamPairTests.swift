//
//  StreamPairTests.swift
//  EMUtilsTests
//
//  Created by Ewan Mellor on 10/18/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class StreamPairTests: XCTestCase {

    func testStreamPairOneWrite() {
        let (istream, ostream) = StreamPair.getStreamPair()

        XCTAssertEqual(istream.streamStatus, .open)
        XCTAssertEqual(ostream.streamStatus, .open)
        XCTAssertFalse(istream.hasBytesAvailable)
        XCTAssert(ostream.hasSpaceAvailable)

        let buf = Data(bytes: [1, 2, 3])
        let writtenCount = buf.withUnsafeBytes {
            ostream.write($0, maxLength: buf.count)
        }
        XCTAssertEqual(writtenCount, 3)
        XCTAssert(istream.hasBytesAvailable)

        var resultBuf = Data(repeating: 0, count: 16)
        let readCount = resultBuf.withUnsafeMutableBytes {
            return istream.read($0, maxLength: 16)
        }
        XCTAssertEqual(readCount, 3)
        XCTAssertEqual(resultBuf[..<readCount], buf)

        XCTAssertEqual(istream.streamStatus, .open)
        XCTAssertEqual(ostream.streamStatus, .open)

        istream.close()
        ostream.close()
        XCTAssertEqual(istream.streamStatus, .closed)
        XCTAssertEqual(ostream.streamStatus, .closed)
    }


    func testStreamPairMultipleWrites() {
        let (istream, ostream) = StreamPair.getStreamPair()

        XCTAssertFalse(istream.hasBytesAvailable)
        XCTAssert(ostream.hasSpaceAvailable)

        var buf = Data(bytes: [1, 2, 3])
        writeBuf(buf, istream, ostream)
        buf = Data(bytes: [4, 5, 6, 7, 8, 9, 10])
        writeBuf(buf, istream, ostream)
        buf = Data(bytes: [11, 12, 13, 14, 15, 16])
        writeBuf(buf, istream, ostream)
        buf = Data(bytes: [17])
        writeBuf(buf, istream, ostream)
        buf = Data(bytes: [])
        writeBuf(buf, istream, ostream)
        buf = Data(bytes: [18, 19, 20])
        writeBuf(buf, istream, ostream)
        ostream.close()

        XCTAssertEqual(istream.streamStatus, .open)
        XCTAssertEqual(ostream.streamStatus, .closed)

        let result = readAll(istream)
        let expected = Data(bytes: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                                    11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
        XCTAssertEqual(result, expected)

        XCTAssertEqual(istream.streamStatus, .atEnd)
        istream.close()
        XCTAssertEqual(istream.streamStatus, .closed)
    }


    private func readAll(_ istream: InputStream) -> Data {
        var result = Data()
        while true {
            var buf = Data(repeating: 0, count: 16)
            let readCount = buf.withUnsafeMutableBytes {
                return istream.read($0, maxLength: 16)
            }
            if readCount == 0 {
                return result
            }
            result.append(buf[0 ..< readCount])
        }
    }


    private func writeBuf(_ buf: Data, _ istream: InputStream, _ ostream: OutputStream) {
        let writtenCount = buf.withUnsafeBytes {
            ostream.write($0, maxLength: buf.count)
        }
        XCTAssertEqual(writtenCount, buf.count)
        XCTAssert(istream.hasBytesAvailable)
    }
}
