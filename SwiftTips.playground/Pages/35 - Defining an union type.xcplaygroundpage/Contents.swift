//: [Previous](@previous)

/*
 The C language has a construct called `union`, that allows
 a single variable to hold values from different types. While
 Swift does not provide such a construct, it provides enums
 with associated values, which allows us to define a type
 called `Either` that implements an `union` of two types.
 */

import Foundation

enum Either<A, B> {
    case left(A)
    case right(B)
    
    func either(ifLeft: ((A) -> Void)? = nil, ifRight: ((B) -> Void)? = nil) {
        switch self {
        case let .left(a):
            ifLeft?(a)
        case let .right(b):
            ifRight?(b)
        }
    }
}

extension Bool { static func random() -> Bool { return arc4random_uniform(2) == 0 } }

var intOrString: Either<Int, String> = Bool.random() ? .left(2) : .right("Foo")

intOrString.either(ifLeft: { print($0 + 1) }, ifRight: { print($0 + "Bar") })

//: [Next](@next)
