//: [Previous](@previous)

/*
 Swift 5.1 introduced Function Builders: a great
 tool for building custom DSL syntaxes, like SwiftUI.
 However, one doesn't need to be building a
 full-fledged DSL in order to leverage them.
 
 For example, it's possible to write a simple
 Function Builder, whose job will be to compose
 together individual instances of
 `NSAttributedString` through a nicer syntax than
 the standard API.
 */

import UIKit

@_functionBuilder
class NSAttributedStringBuilder {
    static func buildBlock(_ components: NSAttributedString...) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")
        
        return components.reduce(into: result) { (result, current) in result.append(current) }
    }
}

extension NSAttributedString {
    class func composing(@NSAttributedStringBuilder _ parts: () -> NSAttributedString) -> NSAttributedString {
        return parts()
    }
}

let result = NSAttributedString.composing {
    NSAttributedString(string: "Hello",
                       attributes: [.font: UIFont.systemFont(ofSize: 24),
                                    .foregroundColor: UIColor.red])
    NSAttributedString(string: " world!",
                       attributes: [.font: UIFont.systemFont(ofSize: 20),
                                    .foregroundColor: UIColor.orange])
}

result

//: [Next](@next)
