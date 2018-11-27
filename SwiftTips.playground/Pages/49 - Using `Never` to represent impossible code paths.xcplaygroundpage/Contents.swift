//: [Previous](@previous)

/*
 `Never` is quite a peculiar type in the Swift Standard
 Library: it is defined as an empty enum `enum Never { }`.
 
 While this might seem odd at first glance, it actually
 yields a very interesting property: it makes it a type
 that cannot be constructed (i.e. it possesses no instances).
 
 This way, `Never` can be used as a generic parameter to
 let the compiler know that a particular feature will not
 be used.
 */

import Foundation

enum Result<Value, Error> {
    case success(value: Value)
    case failure(error: Error)
}

func willAlwaysSucceed(_ completion: @escaping ((Result<String, Never>) -> Void)) {
    completion(.success(value: "Call was successful"))
}

willAlwaysSucceed( { result in
    switch result {
    case .success(let value):
        print(value)
        // the compilers knows that the `failure` case cannot happen
        // so it doesn't require us to handle it.
    }
})

//: [Next](@next)
