//: [Previous](@previous)

/*
 The keyword `typealias` allows developers to give a new
 name to an already existing type. For instance, Swift
 defines `Void` as a `typealias` of `()`, the empty tuple.
 
 But a less known feature of this mechanism is that it
 allows to assign concrete types to generic parameters,
 or to rename them. This can help make the semantics of
 generic types much clearer, when used in specific use cases.
 */

import Foundation

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

typealias Result<Value> = Either<Value, Error>

typealias IntOrString = Either<Int, String>

//: [Next](@next)
