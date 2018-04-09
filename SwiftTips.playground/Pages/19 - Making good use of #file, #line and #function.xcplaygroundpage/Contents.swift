//: [Previous](@previous)

/*
 Swift exposes three special variables called `#file`, `#line` and
 `#function`, that are respectively set to the name of the current file,
 line and function. Those variables become very useful when writing custom
 logging functions or test predicates.
 */

import Foundation

func log(_ message: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    print("[\(file):\(line)] \(function) - \(message)")
}

func foo() {
    log("Hello world!")
}

foo() // [MyPlayground.playground:17] foo() - Hello world!

//: [Next](@next)
