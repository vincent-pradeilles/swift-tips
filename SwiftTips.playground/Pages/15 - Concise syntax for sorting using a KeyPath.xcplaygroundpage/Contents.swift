//: [Previous](@previous)

/*
 By using a `KeyPath` along with a generic type, a very clean
 and concise syntax for sorting data can be implemented:
 */

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by attribute: KeyPath<Element, T>) -> [Element] {
        return sorted(by: { $0[keyPath: attribute] < $1[keyPath: attribute] })
    }
}

let data = ["Some", "words", "of", "different", "lengths"]

data.sorted(by: \.count) // ["of", "Some", "words", "lengths", "different"]

//: [Next](@next)
