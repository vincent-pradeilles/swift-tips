//: [Previous](@previous)

/*
 During development of a feature that performs some heavy
 computations, it can be helpful to measure just how much
 time a chunk of code takes to run. The `time()` function
 is a nice tool for this purpose, because of how simple it
 is to add and then to remove when it is no longer needed.
 */

import Foundation

func time(averagedExecutions: Int = 1, _ code: () -> Void) {
    let start = Date()
    for _ in 0..<averagedExecutions { code() }
    let end = Date()
    
    let duration = end.timeIntervalSince(start) / Double(averagedExecutions)
    
    print("time: \(duration)")
}

time {
    (0...10_000).map { $0 * $0 }
}
// time: 0.183973908424377

//: [Next](@next)
