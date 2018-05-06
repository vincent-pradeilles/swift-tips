//: [Previous](@previous)

/*
 When we need to apply the standard boolean operators to
 `Optional` booleans, we often end up with a syntax
 unnecessarily crowded with unwrapping operations.
 
 By taking a cue from the world of [three-valued logics](https://en.wikipedia.org/wiki/Three-valued_logic),
 we can define a couple operators that make working with
 `Bool?` values much nicer.
 */

import Foundation

func && (lhs: Bool?, rhs: Bool?) -> Bool? {
    switch (lhs, rhs) {
    case (false, _), (_, false):
        return false
    case let (unwrapLhs?, unwrapRhs?):
        return unwrapLhs && unwrapRhs
    default:
        return nil
    }
}

func || (lhs: Bool?, rhs: Bool?) -> Bool? {
    switch (lhs, rhs) {
    case (true, _), (_, true):
        return true
    case let (unwrapLhs?, unwrapRhs?):
        return unwrapLhs || unwrapRhs
    default:
        return nil
    }
}

false && nil // false
true && nil // nil
[true, nil, false].reduce(true, &&) // false

nil || true // true
nil || false // nil
[true, nil, false].reduce(false, ||) // true

//: [Next](@next)
