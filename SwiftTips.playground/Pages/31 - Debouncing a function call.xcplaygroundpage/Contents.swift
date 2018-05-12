//: [Previous](@previous)

/*
 Debouncing is a very useful tool when dealing with UI inputs.
 Consider a search bar, whose content is used to query an API.
 It wouldn't make sense to perform a request for every character
 the user is typing, because as soon as a new character is entered,
 the result of the previous request has become irrelevant.
 
 Instead, our code will perform much better if we "debounce" the
 API call, meaning that we will wait until some delay has passed,
 without the input being modified, before actually performing the call.
 */

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func debounced(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
    var workItem: DispatchWorkItem?
    
    return {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}

let debouncedPrint = debounced(delay: 1.0) { print("Action performed!") }

debouncedPrint()
debouncedPrint()
debouncedPrint()

// After a 1 second delay, this gets
// printed only once to the console:

// Action performed!

//: [Next](@next)
