//: [Previous](@previous)

import Foundation

/*
 Property Wrappers allow developers to wrap
 properties with specific behaviors, that
 will be seamlessly triggered whenever the
 properties are accessed.

 While their primary use case is to implement
 business logic within our apps, it's also
 possible to use Property Wrappers as debugging tools!

 For example, we could build a wrapper called
 `@History`, that would be added to a property
 while debugging and would keep track of all
 the values set to this property.
 */

@propertyWrapper
struct History<Value> {
    private var value: Value
    private(set) var history: [Value] = []

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { value }

        set {
            history.append(value)
            value = newValue
        }
    }
    
    var projectedValue: Self {
        return self
    }
}

// We can then decorate our business code
// with the `@History` wrapper
struct User {
    @History var name: String = ""
}

var user = User()

// All the existing call sites will still
// compile, without the need for any change
user.name = "John"
user.name = "Jane"

// But now we can also access an history of
// all the previous values!
user.$name.history // ["", "John"]

//: [Next](@next)
