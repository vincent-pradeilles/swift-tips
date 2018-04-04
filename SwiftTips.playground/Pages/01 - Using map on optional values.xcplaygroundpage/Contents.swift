//: [Previous](@previous)

import UIKit

/*
 The if-let syntax is a great way to deal with optional values in a safe manner, but at
 times it can prove to be just a little bit to cumbersome. In such cases, using the
 `Optional.map()` function is a nice way to achieve a shorter code while retaining safeness
 and readability.
 */

let date: Date? = Date() // or could be nil, doesn't matter
let formatter = DateFormatter()
let label = UILabel()

if let safeDate = date {
    label.text = formatter.string(from: safeDate)
}

label.text = date.map { return formatter.string(from: $0) }

label.text = date.map(formatter.string(from:)) // even shorter, tough less readable

//: [Next](@next)
