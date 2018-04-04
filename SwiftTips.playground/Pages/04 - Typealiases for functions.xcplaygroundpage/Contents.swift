//: [Previous](@previous)

/*
 Typealiases are great to express function signatures in a more
 comprehensive manner, which then enables us to easily define functions
 that operate on them, resulting in a nice way to write and use some
 powerful API.
 */

import Foundation

typealias RangeSet = (Int) -> Bool

func union(_ left: @escaping RangeSet, _ right: @escaping RangeSet) -> RangeSet {
    return { left($0) || right($0) }
}

let firstRange = { (0...3).contains($0) }
let secondRange = { (5...6).contains($0) }

let unionRange = union(firstRange, secondRange)

unionRange(2) // true
unionRange(4) // false

//: [Next](@next)
