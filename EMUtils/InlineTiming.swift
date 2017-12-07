//
//  InlineTiming.swift
//  EMUtils iOS
//
//  Created by Ewan Mellor on 11/8/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


#if DEBUG
public let ENABLED = true
#else
public let ENABLED = false
#endif


public struct InlineTiming {
    public let logFunc: (_ format: String, _ args: CVarArg...) -> Void

    public var times = [TimeInterval]()
    public var lines = [Int]()


    @inline(__always)
    public init(logFunc: @escaping (_ format: String, _ args: CVarArg...) -> Void, line: Int = #line) {
        self.logFunc = logFunc

        mark(line: line)
    }


    @inline(__always)
    public mutating func mark(line: Int = #line) {
        if ENABLED {
            times.append(Date.timeIntervalSinceReferenceDate)
            lines.append(line)
        }
    }


    @inline(__always)
    public mutating func end(budget: TimeInterval = 0.0, fun fun_: String = #function, line: Int = #line) {
        if !ENABLED {
            return
        }
        end_(budget: budget, fun: fun_, line: line)
    }

    public mutating func end_(budget: TimeInterval, fun fun_: String, line: Int) {
        mark(line: line)

        let count = lines.count
        if count <= 1 {
            return
        }

        let total_time = times[count - 1] - times[0]
        if total_time < budget {
            return
        }

        let fun = String(fun_.split(separator: "(", maxSplits: 1)[0])

        let well_over_budget = (budget > 0.0 && total_time > (10.0 * budget))
        let well_over_str = well_over_budget ? "⚡" : "  "

        if count == 2 {
            let delta = times[1] - times[0]
            logFunc("%@Timing for %@:%d: %lf", well_over_str, fun, line, delta)
            return
        }

        var deltas = [TimeInterval(0)]
        var max_delta = TimeInterval(0)
        var max_line = 0
        var previous = times[0]
        for i in 1 ..< count {
            let time = times[i]
            let delta = time - previous
            deltas.append(delta)
            previous = time
            if delta > max_delta {
                max_delta = delta
                max_line = lines[i]
            }
        }

        var timings_str = ""
        for i in 1 ..< count {
            let delta = deltas[i]
            let is_max = max_delta - delta < 0.001
            if is_max {
                timings_str = timings_str.appendingFormat(" 👉 %lf 👈", delta)
            }
            else {
                timings_str = timings_str.appendingFormat(" %lf", delta)
            }
        }

        logFunc("%@Timings for %@:%d:%@ = %lf; max of %lf(%0.2lf%%) at line %d",
                well_over_str, fun, line, timings_str, total_time,
                max_delta, 100 * max_delta / total_time,
                max_line)
    }
}
