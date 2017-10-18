//
//  StreamPair.swift
//  EMUtils
//
//  Created by Ewan Mellor on 10/18/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


fileprivate let DUMP_ALL = false


/**
 An InputStream and an OutputStream, bound together with a buffer.  Data
 written to the output stream will appear on the input stream.
 Unlike CFCreateBoundPair, this is safe to be used between threads.
 */
public final class StreamPair {

    public static func getStreamPair() -> (istream: InputStream, ostream: OutputStream) {
        let sp = StreamPair()
        let istream = StreamPairInputStream(sp)
        let ostream = StreamPairOutputStream(sp)
        return (istream: istream, ostream: ostream)
    }


    /**
     Protects all access to buffer, isInputClosed, isOutputClosed.
     */
    fileprivate let condition = NSCondition()

    fileprivate var buffer = [Data]()
    fileprivate var isInputClosed = false
    fileprivate var isOutputClosed = false


    fileprivate init() {
    }


    fileprivate var hasBytesAvailable: Bool {
        condition.lock()
        defer {
            condition.unlock()
        }
        return !buffer.isEmpty
    }


    fileprivate func streamStatus(_ isInputStream: Bool) -> Stream.Status {
        condition.lock()
        defer {
            condition.unlock()
        }

        if isInputClosed {
            return .closed
        }

        if isOutputClosed {
            if isInputStream {
                return buffer.isEmpty ? .atEnd : .open
            }
            else {
                return .closed
            }
        }

        return .open
    }


    fileprivate func read(_ destbuf: UnsafeMutablePointer<UInt8>, maxLength destlen: Int) -> Int {
        var n = 0

        condition.lock()
        defer {
            condition.unlock()
        }

        while true {
            if isInputClosed {
                n = -1
                break
            }
            if buffer.count == 0 {
                if isOutputClosed {
                    n = 0
                    break
                }
                else {
                    condition.wait()
                    continue
                }
            }

            let data = buffer[0]
            let data_len = data.count
            if data_len <= destlen {
                n = data_len
                buffer = Array(buffer[1...])
            }
            else {
                n = destlen
                buffer[0] = data.subdata(in: n ..< data_len - n)
            }
            data.copyBytes(to: destbuf, count: n)
            break
        }

        return n
    }


    fileprivate func write(_ srcbuf: UnsafePointer<UInt8>, maxLength srclen: Int) throws -> Int {
        condition.lock()
        defer {
            condition.broadcast()
            condition.unlock()
        }

        if isOutputClosed {
            throw POSIXError(.EPIPE)
        }

        if srclen > 0 {
            let data = Data(bytes: srcbuf, count: srclen)
            buffer.append(data)

            if DUMP_ALL {
                NSLog("DATA BLOCK: \(data.base64EncodedString())")
            }
        }

        return srclen
    }


    fileprivate func closeInput() {
        condition.lock()
        defer {
            condition.broadcast()
            condition.unlock()
        }
        isInputClosed = true
        isOutputClosed = true
    }


    fileprivate func closeOutput() {
        condition.lock()
        defer {
            condition.broadcast()
            condition.unlock()
        }
        isOutputClosed = true
    }
}


public final class StreamPairInputStream : InputStream {
    private let streamPair: StreamPair

    fileprivate init(_ streamPair: StreamPair) {
        self.streamPair = streamPair
        super.init(data: Data())
    }

    public override var hasBytesAvailable: Bool {
        return streamPair.hasBytesAvailable
    }

    public override var streamError: Error? {
        return nil
    }

    public override var streamStatus: Stream.Status {
        return streamPair.streamStatus(true)
    }

    public override func open() {
    }

    public override func close() {
        streamPair.closeInput()
    }

    public override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        return streamPair.read(buffer, maxLength: len)
    }

    public override func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return false
    }

    public override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        fatalError("Not implemented")
    }

    public override func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode) {
        fatalError("Not implemented")
    }
}


public final class StreamPairOutputStream : OutputStream {
    public var lastError: Error?

    private let streamPair: StreamPair

    fileprivate init(_ streamPair: StreamPair) {
        self.streamPair = streamPair
        super.init(toMemory: ())
    }

    public override var hasSpaceAvailable: Bool {
        return true
    }

    public override var streamError: Error? {
        return lastError
    }

    public override var streamStatus: Stream.Status {
        return streamPair.streamStatus(false)
    }


    public override func open() {
    }

    public override func close() {
        streamPair.closeOutput()
    }

    public override func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        do {
            return try streamPair.write(buffer, maxLength: len)
        }
        catch let err {
            lastError = err
            return -1
        }
    }

    public override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoopMode) {
    }

    public override func remove(from aRunLoop: RunLoop, forMode mode: RunLoopMode) {
    }
}
