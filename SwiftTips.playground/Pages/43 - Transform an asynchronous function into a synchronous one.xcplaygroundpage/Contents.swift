//: [Previous](@previous)

/*
 Asynchronous functions are a great way to deal with future
 events without blocking a thread. Yet, there are times
 where we would like them to behave in exactly such a
 blocking way.
 
 Think about writing unit tests and using mocked network calls.
 You will need to add complexity to your test in order to deal
 with asynchronous functions, whereas synchronous ones would
 be much easier to manage.
 
 Thanks to Swift proficiency in the functional paradigm, it is
 possible to write a function whose job is to take an
 asynchronous function and transform it into a synchronous one.
 */
import Foundation

func makeSynchrone<A, B>(_ asyncFunction: @escaping (A, (B) -> Void) -> Void) -> (A) -> B {
    return { arg in
        let lock = NSRecursiveLock()
        
        var result: B? = nil
        
        asyncFunction(arg) {
            result = $0
            lock.unlock()
        }
        
        lock.lock()
        
        return result!
    }
}

func myAsyncFunction(arg: Int, completionHandler: (String) -> Void) {
    completionHandler("🎉 \(arg)")
}

let syncFunction = makeSynchrone(myAsyncFunction)

print(syncFunction(42)) // prints 🎉 42

//: [Next](@next)
