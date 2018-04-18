//: [Previous](@previous)

/*
 Surprisingly enough, the standard library doesn't define a `map()`
 function for dictionaries that allows to map both `keys` and `values`
 into a new `Dictionary`. Nevertheless, such a function can be helpful,
 for instance when converting data across different frameworks.
 */

import Foundation

extension Dictionary {
    func map<T: Hashable, U>(_ transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        
        return result
    }
}

let data = [0: 5, 1: 6, 2: 7]
data.map { ("\($0)", $1 * $1) } // ["2": 49, "0": 25, "1": 36]

//: [Next](@next)
