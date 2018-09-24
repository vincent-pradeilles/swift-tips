//: [Previous](@previous)

/*
 Asynchronous functions are a big part of iOS APIs, and most
 developers are familiar with the challenge they pose when
 one needs to sequentially call several asynchronous APIs.
 
 This often results in callbacks being nested into one another,
 a predicament often referred to as callback hell.
 
 Many third-party frameworks are able to tackle this issue,
 for instance [RxSwift](https://github.com/ReactiveX/RxSwift)
 or [PromiseKit](https://github.com/mxcl/PromiseKit).
 Yet, for simple instances of the problem, there is no need
 to use such big guns, as it can actually be solved with
 simple function composition.
 */

import Foundation

typealias CompletionHandler<Result> = (Result?, Error?) -> Void

infix operator ~>: MultiplicationPrecedence

func ~> <T, U>(_ first: @escaping (CompletionHandler<T>) -> Void, _ second: @escaping (T, CompletionHandler<U>) -> Void) -> (CompletionHandler<U>) -> Void {
    return { completion in
        first({ firstResult, error in
            guard let firstResult = firstResult else { completion(nil, error); return }
            
            second(firstResult, { (secondResult, error) in
                completion(secondResult, error)
            })
        })
    }
}

func ~> <T, U>(_ first: @escaping (CompletionHandler<T>) -> Void, _ transform: @escaping (T) -> U) -> (CompletionHandler<U>) -> Void {
    return { completion in
        first({ result, error in
            guard let result = result else { completion(nil, error); return }
            
            completion(transform(result), nil)
        })
    }
}

func service1(_ completionHandler: CompletionHandler<Int>) {
    completionHandler(42, nil)
}

func service2(arg: String, _ completionHandler: CompletionHandler<String>) {
    completionHandler("🎉 \(arg)", nil)
}

let chainedServices = service1
    ~> { int in return String(int / 2) }
    ~> service2

chainedServices({ result, _ in
    guard let result = result else { return }
    
    print(result) // Prints: 🎉 21
})

//: [Next](@next)
