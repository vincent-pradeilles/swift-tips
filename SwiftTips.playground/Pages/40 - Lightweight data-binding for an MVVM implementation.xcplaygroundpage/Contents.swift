//: [Previous](@previous)

/*
 MVVM is a great pattern to separate business logic from
 presentation logic. The main challenge to make it work,
 is to define a mechanism for the presentation layer to
 be notified of model updates.
 
 [RxSwift](https://github.com/ReactiveX/RxSwift) is a
 perfect choice to solve such a problem. Yet, some
 developers don't feel confortable with leveraging a
 third-party library for such a central part of their
 architecture.
 
 For those situation, it's possible to define a
 lightweight `Variable` type, that will make the MVVM
 pattern very easy to use!
 */

import Foundation

class Variable<Value> {
    var value: Value {
        didSet {
            onUpdate?(value)
        }
    }
    
    var onUpdate: ((Value) -> Void)? {
        didSet {
            onUpdate?(value)
        }
    }
    
    init(_ value: Value, _ onUpdate: ((Value) -> Void)? = nil) {
        self.value = value
        self.onUpdate = onUpdate
        self.onUpdate?(value)
    }
}

let variable: Variable<String?> = Variable(nil)

variable.onUpdate = { data in
    if let data = data {
        print(data)
    }
}

variable.value = "Foo"
variable.value = "Bar"

// prints:
// Foo
// Bar

//: [Next](@next)
