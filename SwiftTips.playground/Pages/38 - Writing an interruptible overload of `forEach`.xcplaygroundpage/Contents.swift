//: [Previous](@previous)

/*
 Iterating through objects via the `forEach(_:)` method is
 a great alternative to the classic `for` loop, as it allows
 our code to be completely oblivious of the iteration logic.
 One limitation, however, is that `forEach(_:)` does not
 allow to stop the iteration midway.
 
 Taking inspiration from the [Objective-C implementation](https://developer.apple.com/documentation/foundation/nsarray/1415846-enumerateobjectsusingblock),
 we can write an overload that will allow the developer
 to stop the iteration, if needed.
 */

import Foundation

extension Sequence {
    func forEach(_ body: (Element, _ stop: inout Bool) throws -> Void) rethrows {
        var stop = false
        for element in self {
            try body(element, &stop)
            
            if stop {
                return
            }
        }
    }
}

["Foo", "Bar", "FooBar"].forEach { element, stop in
    print(element)
    stop = (element == "Bar")
}

// Prints:
// Foo
// Bar

//: [Next](@next)
