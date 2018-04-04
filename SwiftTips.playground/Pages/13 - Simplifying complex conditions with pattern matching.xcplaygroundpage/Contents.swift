//: [Previous](@previous)

/*
 When distinguishing between complex boolean conditions,
 using a `switch` statement along with pattern matching
 can be more readable than the classic series
 of `if {} else if {}`.
 */

import Foundation

let expr1: Bool
let expr2: Bool
let expr3: Bool

if expr1 && !expr3 {
    functionA()
} else if !expr2 && expr3 {
    functionB()
} else if expr1 && !expr2 && expr3 {
    functionC()
}

switch (expr1, expr2, expr3) {
    
case (true, _, false):
    functionA()
case (_, false, true):
    functionB()
case (true, false, true):
    functionC()
default:
    break
}

//: [Next](@next)
