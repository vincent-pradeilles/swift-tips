//: [Previous](@previous)

/*
 It's common knowledge for Swift developers that,
 when you define a `struct`, the compiler is going
 to automatically generate a memberwise `init` for
 you. That is, unless you also define an `init` of
 your own. Because then, the compiler won't
 generate any memberwise `init`.
 
 Yet, there are many instances where we might enjoy
 the opportunity to get both. As it turns out, this
 goal is quite easy to achieve: you just need to
 define your own `init` in an `extension` rather
 than inside the type definition itself.
 */

import Foundation

struct Point {
    let x: Int
    let y: Int
}

extension Point {
    init() {
        x = 0
        y = 0
    }
}

let usingDefaultInit = Point(x: 4, y: 3)
let usingCustomInit = Point()

//: [Next](@next)
