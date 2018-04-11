//: [Previous](@previous)

/*
 Concurrency is definitely one of those topics were the
 right encapsulation bears the potential to make your life
 so much easier. For instance, with this piece of code you
 can easily launch two computations in parallel, and have
 the results returned in a tuple.
 */

import Foundation

func parallel<T, U>(_ left: @autoclosure () -> T, _ right: @autoclosure () -> U) -> (T, U) {
    var leftRes: T?
    var rightRes: U?
    
    DispatchQueue.concurrentPerform(iterations: 2, execute: { id in
        if id == 0 {
            leftRes = left()
        } else {
            rightRes = right()
        }
    })
    
    return (leftRes!, rightRes!)
}

let values = (1...100_000).map { $0 }

let results = parallel(values.map { $0 * $0 }, values.reduce(0, +))

//: [Next](@next)
