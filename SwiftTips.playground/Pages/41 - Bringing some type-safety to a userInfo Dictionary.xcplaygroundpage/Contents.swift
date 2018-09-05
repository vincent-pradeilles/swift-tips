//: [Previous](@previous)

/*
 Many iOS APIs still rely on a `userInfo` `Dictionary`
 to handle use-case specific data. This `Dictionary`
 usually stores untyped values, and is declared as
 follows: `[String: Any]` (or sometimes `[AnyHashable: Any]`.
 
 Retrieving data from such a structure will involve
 some conditional casting (via the `as?` operator),
 which is prone to both errors and repetitions. Yet,
 by introducing a custom `subscript`, it's possible
 to encapsulate all the tedious logic, and end-up
 with an easier and more robust API.
 */

import Foundation

typealias TypedUserInfoKey<T> = (key: String, type: T.Type)

extension Dictionary where Key == String, Value == Any {
    subscript<T>(_ typedKey: TypedUserInfoKey<T>) -> T? {
        return self[typedKey.key] as? T
    }
}

let userInfo: [String : Any] = ["Foo": 4, "Bar": "forty-two"]

let integerTypedKey = TypedUserInfoKey(key: "Foo", type: Int.self)
let intValue = userInfo[integerTypedKey] // returns 4
type(of: intValue) // returns Int?

let stringTypedKey = TypedUserInfoKey(key: "Bar", type: String.self)
let stringValue = userInfo[stringTypedKey] // returns "forty-two"
type(of: stringValue) // returns String?

//: [Next](@next)
