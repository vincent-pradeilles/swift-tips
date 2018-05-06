//: [Previous](@previous)

/*
 Transforming a `Sequence` in order to remove all the duplicate
 values it contains is a classic use case. To implement it, one
 could be tempted to transform the `Sequence` into a `Set`, then
 back to an `Array`. The downside with this approach is that it
 will not preserve the  order of the sequence, which can definitely
 be a dealbreaker.
 
 Using `reduce()` it is possible to provide a concise implementation
 that preserves ordering:
 */

import Foundation

extension Sequence where Element: Equatable {
    func duplicatesRemoved() -> [Element] {
        return reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
    }
}

let data = [2, 5, 2, 3, 6, 5, 2]

data.duplicatesRemoved() // [2, 5, 3, 6]

//: [Next](@next)
