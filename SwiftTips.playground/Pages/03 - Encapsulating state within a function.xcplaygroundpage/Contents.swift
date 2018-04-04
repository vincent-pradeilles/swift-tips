//: [Previous](@previous)

/*
 By returning a closure that captures a local variable, it's possible to
 encapsulate a mutable state within a function.
 */

import Foundation

func counterFactory() -> () -> Int {
    var counter = 0
    
    return {
        counter += 1
        return counter
    }
}

let counter = counterFactory()

counter() // returns 1
counter() // returns 2

//: [Next](@next)
