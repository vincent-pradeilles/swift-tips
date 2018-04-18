//: [Previous](@previous)

/*
 Swift provides the function `compactMap()`, that can be used
 to remove `nil` values from a `Sequence` of optionals when calling it
 with an argument that just returns its parameter (i.e. `compactMap { $0 }`).
 Still, for such use cases it would be nice to get rid of the trailing closure.
 
 The implementation isn't as straightforward as your usual `extension`,
 but once it has been written, the call site definitely gets cleaner 👌
 */

import Foundation

protocol OptionalConvertible {
    associatedtype Wrapped
    func asOptional() -> Wrapped?
}

extension Optional: OptionalConvertible {
    func asOptional() -> Wrapped? {
        return self
    }
}

extension Sequence where Element: OptionalConvertible {
    func compacted() -> [Element.Wrapped] {
        return compactMap { $0.asOptional() }
    }
}

let data = [nil, 1, 2, nil, 3, 5, nil, 8, nil]
data.compacted() // [1, 2, 3, 5, 8]

//: [Next](@next)
