//: [Previous](@previous)

/*
 Functional programing is a great way to simplify a codebase.
 For instance, `reduce` is an alternative to the classic `for`
 loop, without most the boilerplate. Unfortunately, simplicity
 often comes at the price of performance.
 
 Consider that you want to remove duplicate values from
 a `Sequence`. While `reduce()` is a perfectly fine way to
 express this computation, the performance will be sub optimal,
 because of all the unnecessary array copying that will happen
 every time its closure gets called.
 
 That's when `reduce(into:_:)` comes into play. This version of
 `reduce` leverages the capacities of copy-on-write type (such
 as `Array` or `Dictionnary`) in order to avoid unnecessary
 copying, which results in a great performance boost.
 */

import Foundation

func time(averagedExecutions: Int = 1, _ code: () -> Void) {
    let start = Date()
    for _ in 0..<averagedExecutions { code() }
    let end = Date()
    
    let duration = end.timeIntervalSince(start) / Double(averagedExecutions)
    
    print("time: \(duration)")
}

let data = (1...1_000).map { _ in Int(arc4random_uniform(256)) }


// runs in 0.63s
time {
    let noDuplicates: [Int] = data.reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
}

// runs in 0.15s
time {
    let noDuplicates: [Int] = data.reduce(into: [], { if !$0.contains($1) { $0.append($1) } } )
}

//: [Next](@next)
