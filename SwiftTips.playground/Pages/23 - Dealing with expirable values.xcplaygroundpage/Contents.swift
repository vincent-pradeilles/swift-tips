//: [Previous](@previous)

/*
 It might happen that your code has to deal with values that
 come with an expiration data. In a game, it could be a score
 multiplier that will only last for 30 seconds. Or it could be
 an authentication token for an API with a 15 minutes lifespan.
 In both instances you can rely on the type `Expirable` to
 encapsulate the expiration logic.
 */

import Foundation

struct Expirable<T> {
    var expirationDate: Date
    private var innerValue: T
    
    var value: T? {
        return expired() ? innerValue : nil
    }
    
    init(value: T, expirationDate: Date) {
        self.innerValue = value
        self.expirationDate = expirationDate
    }
    
    init(value: T, duration: Double) {
        self.innerValue = value
        self.expirationDate = Date().addingTimeInterval(duration)
    }
    
    func expired() -> Bool {
        return expirationDate.timeIntervalSince(Date()) > 0
    }
}

let expirable = Expirable(value: 42, duration: 3)

sleep(2)
expirable.value // 42
sleep(2)
expirable.value // nil

//: [Next](@next)
