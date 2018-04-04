//: [Previous](@previous)

/*
 Using `map()` on a range makes it easy to generate
 an array of data.
 */
import Foundation

func randomInt() -> Int { return Int(arc4random()) }

let randomArray = (1...10).map { _ in randomInt() }

//: [Next](@next)
