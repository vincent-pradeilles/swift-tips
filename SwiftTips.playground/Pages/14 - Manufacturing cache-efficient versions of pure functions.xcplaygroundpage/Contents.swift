//: [Previous](@previous)

/*
 By capturing a local variable in a returned closure, it is
 possible to manufacture cache-efficient versions of
 [pure functions](https://en.wikipedia.org/wiki/Pure_function).
 Be careful though, this trick only works with non-recursive function!
 */
import Foundation

func cached<In: Hashable, Out>(_ f: @escaping (In) -> Out) -> (In) -> Out {
    var cache = [In: Out]()
    
    return { (input: In) -> Out in
        if let cachedValue = cache[input] {
            return cachedValue
        } else {
            let result = f(input)
            cache[input] = result
            return result
        }
    }
}

let cachedCos = cached { (x: Double) in cos(x) }

cachedCos(.pi * 2) // value of cos for 2π is now cached

//: [Next](@next)
