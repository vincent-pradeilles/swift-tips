//: [Previous](@previous)

/*
 Closures are a great way to interact with generic APIs,
 for instance APIs that allow to manipulate data
 structures through the use of generic functions, such as
 `filter()` or `sorted()`.
 
 The annoying part is that closures tend to clutter your
 code with many instances of `{`, `}` and `$0`, which can
 quickly undermine its readably.
 
 A nice alternative for a cleaner syntax is to use a
 `KeyPath` instead of a closure, along with an operator
 that will deal with transforming the provided `KeyPath`
 in a closure.
 */

import Foundation

prefix operator ^

prefix func ^ <Element, Attribute>(_ keyPath: KeyPath<Element, Attribute>) -> (Element) -> Attribute {
    return { element in element[keyPath: keyPath] }
}

struct MyData {
    let int: Int
    let string: String
}

let data = [MyData(int: 2, string: "Foo"), MyData(int: 4, string: "Bar")]

data.map(^\.int) // [2, 4]
data.map(^\.string) // ["Foo", "Bar"]

//: [Next](@next)
