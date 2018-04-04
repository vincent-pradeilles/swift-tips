//: [Previous](@previous)

/*
 When working with RxSwift, it's very easy to observe
 both the current and previous value of an observable
 sequence by simply introducing a shift using `skip()`.
 */

import RxSwift

let values = Observable.of(4, 8, 15, 16, 23, 42)

let newAndOld = Observable.zip(values, values.skip(1)) { (previous: $0, current: $1) }
    .subscribe(onNext: { pair in
        print("current: \(pair.current) - previous: \(pair.previous)")
    })

//current: 8 - previous: 4
//current: 15 - previous: 8
//current: 16 - previous: 15
//current: 23 - previous: 16
//current: 42 - previous: 23

//: [Next](@next)
