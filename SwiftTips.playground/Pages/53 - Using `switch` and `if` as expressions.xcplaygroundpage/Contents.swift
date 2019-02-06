//: [Previous](@previous)

/*
 Contrary to other languages, like Kotlin, Swift
 does not allow `switch` and `if` to be used as
 expressions. Meaning that the following code is
 not valid Swift:
 
 ```swift
 let constant = if condition {
                   someValue
                } else {
                   someOtherValue
                }
 ```
 
 A common solution to this problem is to wrap the
 `if` or `switch` statement within a closure, that
 will then be immediately called. While this
 approach does manage to achieve the desired goal,
 it makes for a rather poor syntax.
 
 To avoid the ugly trailing `()` and improve on the
 readability, you can define a `resultOf` function,
 that will serve the exact same purpose, in a more
 elegant way.
 */

import Foundation

func resultOf<T>(_ code: () -> T) -> T {
    return code()
}

let randomInt = Int.random(in: 0...3)

let spelledOut: String = resultOf {
    switch randomInt {
    case 0:
        return "Zero"
    case 1:
        return "One"
    case 2:
        return "Two"
    case 3:
        return "Three"
    default:
        return "Out of range"
    }
}

print(spelledOut)

//: [Next](@next)
