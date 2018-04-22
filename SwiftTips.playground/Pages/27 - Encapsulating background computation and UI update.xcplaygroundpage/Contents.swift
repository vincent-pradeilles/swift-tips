//: [Previous](@previous)

/*
 Every seasoned iOS developers knows it: objects from `UIKit`
 can only be accessed from the main thread. Any attempt to
 access them from a background thread is a guaranteed crash.
 
 Still, running a costly computation on the background, and
 then using it to update the UI can be a common pattern.
 
 In such cases you can rely on `asyncUI` to encapsulate all
 the boilerplate code.
 */

import Foundation
import UIKit

func asyncUI<T>(_ computation: @autoclosure @escaping () -> T, qos: DispatchQoS.QoSClass = .userInitiated, _ completion: @escaping (T) -> Void) {
    DispatchQueue.global(qos: qos).async {
        let value = computation()
        DispatchQueue.main.async {
            completion(value)
        }
    }
}

let label = UILabel()

func costlyComputation() -> Int { return (0..<10_000).reduce(0, +) }

asyncUI(costlyComputation()) { value in
    label.text = "\(value)"
}

//: [Next](@next)
