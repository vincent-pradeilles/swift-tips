//: [Previous](@previous)

/*
 Optional strings are very common in Swift code, for instance
 many objects from `UIKit` expose the text they display as a
 `String?`. Many times you will need to manipulate this data
 as an unwrapped `String`, with a default value set to the
 empty string for `nil` cases.
 
 While the nil-coalescing operator (e.g. `??`) is a perfectly
 fine way to a achieve this goal, defining a computed variable
 like `orEmpty` can help a lot in cleaning the syntax.
 */

import Foundation
import UIKit

extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}

func doesNotWorkWithOptionalString(_ param: String) {
    // do something with `param`
}

let label = UILabel()
label.text = "This is some text."

doesNotWorkWithOptionalString(label.text.orEmpty)

//: [Next](@next)
