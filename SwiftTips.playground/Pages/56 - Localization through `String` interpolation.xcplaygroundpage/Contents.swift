//: [Previous](@previous)

/*
 Swift 5 gave us the possibility to define
 our own custom `String` interpolation methods.
 
 This feature can be used to power many use
 cases, but there is one that is guaranteed
 to make sense in most projects: localizing
 user-facing strings.
 */

import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(localized key: String, _ args: CVarArg...) {
        let localized = String(format: NSLocalizedString(key, comment: ""), arguments: args)
        appendLiteral(localized)
    }
}


/*
 Let's assume that this is the content of our Localizable.strings:
 
 "welcome.screen.greetings" = "Hello %@!";
 */

let userName = "John"
print("\(localized: "welcome.screen.greetings", userName)") // Hello John!

//: [Next](@next)
