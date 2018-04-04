//: [Previous](@previous)

/*
 Any attempt to access an `Array` beyond its bounds will
 result in a crash. While it's possible to write conditions
 such as `if index < array.count { array[index] }` in order
 to prevent such crashes, this approach will rapidly become
 cumbersome.
 
 A great thing is that this condition can be encapsulated in
 a custom `subscript` that will work on any `Collection`:
 */
import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let data = [1, 3, 4]

data[safe: 1] // Optional(3)
data[safe: 10] // nil

//: [Next](@next)
