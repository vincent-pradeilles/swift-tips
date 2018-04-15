//: [Previous](@previous)

/*
 With the addition of keypaths in Swift 4, it is now possible
 to easily implement the builder pattern, that allows the
 developer to clearly separate the code that initializes a value
 from the code that uses it, without the burden of defining a
 factory method.
 
 🚨 The Swift compiler **does not** perform OS availability checks
 on properties referenced by keypaths. Any attempt to use a `KeyPath`
 for an unavailable property will result in a runtime crash.
 */

import UIKit

protocol With {}

extension With where Self: AnyObject {
    @discardableResult
    func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}

extension UIView: With {}

let view = UIView()

let label = UILabel()
    .with(\.textColor, setTo: .red)
    .with(\.text, setTo: "Foo")
    .with(\.textAlignment, setTo: .right)
    .with(\.layer.cornerRadius, setTo: 5)

view.addSubview(label)

//: [Next](@next)
