//: [Previous](@previous)

/*
 Swift 4.1 has introduced a new feature called Conditional Conformance,
 which allows a type to implement a protocol only when its generic type also does.
 
 With this addition it becomes easy to let `Optional` implement `Comparable`
 only when `Wrapped` also implements `Comparable`:
 */

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        switch (lhs, rhs) {
        case let (lhs?, rhs?):
            return lhs < rhs
        case (nil, _?):
            return true // anything is greater than nil
        case (_?, nil):
            return false // nil in smaller than anything
        case (nil, nil):
            return true // nil is not smaller than itself
        }
    }
}

let data: [Int?] = [8, 4, 3, nil, 12, 4, 2, nil, -5]
data.sorted() // [nil, nil, Optional(-5), Optional(2), Optional(3), Optional(4), Optional(4), Optional(8), Optional(12)]

//: [Next](@next)
