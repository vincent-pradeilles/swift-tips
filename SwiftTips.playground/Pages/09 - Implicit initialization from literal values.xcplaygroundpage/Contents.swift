//: [Previous](@previous)

/*
 Using protocols such as `ExpressibleByStringLiteral` it
 is possible to provide an `init` that will be automatically
 when a literal value is provided, allowing for nice and short
 syntax. This can be very helpful when writing mock or test data.
 */

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}

let url: URL = "http://www.google.fr"

NSURLConnection.canHandle(URLRequest(url: "http://www.google.fr"))

//: [Next](@next)
