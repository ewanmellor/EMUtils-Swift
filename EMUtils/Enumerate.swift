//
//  Enumerate.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation


public class Enumerate {

    /**
     Call the given block with pairs taken from s1 and s2 in sequence.

     If one sequence is shorter than the other, then the iteration will only
     run as long as the shorter one. The remaining items in the longer one
     will be ignored.
     */
    public class func pairwiseOver<S1, S2, E1, E2 where S1 : SequenceType, S2: SequenceType, E1 == S1.Generator.Element, E2 == S2.Generator.Element>(s1: S1, and s2: S2, block: (E1, E2) -> Void) {
        Enumerate.pairwiseOver(s1, and: s2, blockWithResult: { (e1: E1, e2: E2) -> (Bool, Any?) in
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
    public class func pairwiseOver<S1, S2, E1, E2, V where S1 : SequenceType, S2: SequenceType, E1 == S1.Generator.Element, E2 == S2.Generator.Element>(s1: S1, and s2: S2, blockWithResult block: (E1, E2) -> (Bool, V?)) -> V? {
        var g1 = s1.generate()
        var g2 = s2.generate()
        var result: V? = nil

        while let e1 = g1.next(), e2 = g2.next() {
            let (done, val) = block(e1, e2)
            result = val

            if done {
                return result
            }
        }

        return result
    }
}
