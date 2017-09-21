//
//  Enumerate.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation


public final class Enumerate {

    /**
     Call the given block with pairs taken from s1 and s2 in sequence.

     If one sequence is shorter than the other, then the iteration will only
     run as long as the shorter one. The remaining items in the longer one
     will be ignored.
     */
    public static func pairwise<S1, S2>(_ s1: S1, _ s2: S2, _ block: (S1.Iterator.Element, S2.Iterator.Element) -> Void) where S1: Sequence, S2: Sequence {
        var i1 = s1.makeIterator()
        var i2 = s2.makeIterator()
        pairwiseIterator(&i1, &i2, block)
    }

    public static func pairwiseIterator<I1, I2>(_ s1: inout I1, _ s2: inout I2, _ block: (I1.Element, I2.Element) -> Void) where I1: IteratorProtocol, I2: IteratorProtocol {
        let _ = Enumerate.pairwiseIteratorWithResult(&s1, &s2, { (e1: I1.Element, e2: I2.Element) -> (Bool, Any?) in
            block(e1, e2)
            return (false, nil)
        })
    }


    /**
     The same as `Enumerate.pairwiseOver(:and:usingBlock:)` except that the
     block may return a result and may abort the loop.

     - parameter block: Receives `(e1: E1, e2: E2)` and returns
     `(done: Bool, result: V?)`.  If done is true, then the loop will
     terminate with this iteration.
     - returns: The result returned by the block at the end of the last
     iteration of the loop.
     */
    public static func pairwiseWithResult<S1, S2, V>(_ s1: S1, _ s2: S2, _ block: (S1.Iterator.Element, S2.Iterator.Element) -> (Bool, V?)) -> V? where S1: Sequence, S2: Sequence {
        var i1 = s1.makeIterator()
        var i2 = s2.makeIterator()
        let result = pairwiseIteratorWithResult(&i1, &i2, { (e1: S1.Iterator.Element, e2: S2.Iterator.Element) -> (Bool, V?) in
            return block(e1, e2)
        })
        return result
    }

    public static func pairwiseIteratorWithResult<I1, I2, V>(_ i1: inout I1, _ i2: inout I2, _ block: (I1.Element, I2.Element) -> (Bool, V?)) -> V? where I1: IteratorProtocol, I2: IteratorProtocol {
        var result: V? = nil

        while let e1 = i1.next(), let e2 = i2.next() {
            let (done, val) = block(e1, e2)
            result = val

            if done {
                return result
            }
        }

        return result
    }
}
