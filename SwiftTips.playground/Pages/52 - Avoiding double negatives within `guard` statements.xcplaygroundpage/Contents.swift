//: [Previous](@previous)

/*
 A `guard` statement is a very convenient way for
 the developer to assert that a condition is met,
 in order for the execution of the program to keep
 going.
 
 However, since the body of a `guard` statement is
 meant to be executed when the condition evaluates
 to `false`, the use of the negation (`!`) operator
 within the condition of a `guard` statement can
 make the code hard to read, as it becomes a double
 negative.
 
 A nice trick to avoid such double negatives is to
 encapsulate the use of the `!` operator within a
 new property or function, whose name does not
 include a negative.
 */

import Foundation

extension Collection {
    var hasElements: Bool {
        return !isEmpty
    }
}

let array = Bool.random() ? [1, 2, 3] : []

guard array.hasElements else { fatalError("array was empty") }

print(array)

//: [Next](@next)
