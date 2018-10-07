//: [Previous](@previous)

/*
 Callbacks are a part of almost all iOS apps, and as frameworks
 such as `RxSwift` keep gaining in popularity, they become ever
 more present in our codebase.
 
 Seasoned Swift developers are aware of the potential memory
 leaks that `@escaping` callbacks can produce, so they make
 real sure to always use `[weak self]`, whenever they need to
 use `self` inside such a context. And when they need to have
 `self` be non-optional, they then add a `guard` statement along.
 
 Consequently, this syntax of a `[weak self]` followed by
 a `guard` rapidly tends to appear everywhere in the codebase.
 The good thing is that, through a little protocol-oriented
 trick, it's actually possible to get rid of this tedious
 syntax, without loosing any of its benefits!
 */

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

protocol Weakifiable: class { }

extension Weakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            
            code(arg, self)
        }
    }
}

extension NSObject: Weakifiable { }

class Producer: NSObject {
    
    deinit {
        print("deinit Producer")
    }
    
    private var handler: (Int) -> Void = { _ in }
    
    func register(handler: @escaping (Int) -> Void) {
        self.handler = handler
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { self.handler(42) })
    }
}

class Consumer: NSObject {
    
    deinit {
        print("deinit Consumer")
    }
    
    let producer = Producer()
    
    func consume() {
        producer.register(handler: weakify { result, strongSelf in
            strongSelf.handle(result)
        })
    }
    
    private func handle(_ result: Int) {
        print("🎉 \(result)")
    }
}

var consumer: Consumer? = Consumer()

consumer?.consume()

DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { consumer = nil })

// This code prints:
// 🎉 42
// deinit Consumer
// deinit Producer

//: [Next](@next)
