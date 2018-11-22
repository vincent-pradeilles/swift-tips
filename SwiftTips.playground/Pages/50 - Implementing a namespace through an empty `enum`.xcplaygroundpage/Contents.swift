//: [Previous](@previous)

/*
 Swift does not really have an out-of-the-box support
 of namespaces. One could argue that a Swift module
 can be seen as a namespace, but creating a dedicated
 Framework for this sole purpose can legitimately be
 regarded as overkill.
 
 Some developers have taken the habit to use a `struct`
 which only contains `static` fields to implement a
 namespace. While this does the job, it requires us to
 remember to implement an empty `private` `init()`,
 because it wouldn't make sense for such a `struct` to
 be instantiated.
 
 It's actually possible to take this approach one step
 further, by replacing the `struct` with an `enum`.
 While it might seem weird to have an `enum` with no
 `case`, it's actually a [very idiomatic way](https://github.com/apple/swift/blob/a4230ab2ad37e37edc9ed86cd1510b7c016a769d/stdlib/public/core/Unicode.swift#L918)
 to declare a type that cannot be instantiated.
 */

import Foundation

enum NumberFormatterProvider {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingIncrement = 0.01
        return formatter
    }
    
    static var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }
}

NumberFormatterProvider() // ❌ impossible to instantiate by mistake

NumberFormatterProvider.currencyFormatter.string(from: 2.456) // $2.46
NumberFormatterProvider.decimalFormatter.string(from: 2.456) // 2,456

//: [Next](@next)
