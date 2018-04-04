//: [Previous](@previous)

/*
 Subscripting a string with a range can be very cumbersome
 in Swift 4. Let's face it, no one wants to write lines like
 `someString[index(startIndex, offsetBy: 0)..<index(startIndex, offsetBy: 10)]`
 on a regular basis.
 
 Luckily, with the addition of one clever extension, strings can
 be sliced as easily as arrays 🎉
 */
import Foundation

extension String {
    public subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    public subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    public subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    public subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    public subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
}

let data = "This is a string!"

data[..<4]  // "This"
data[5..<9] // "is a"
data[10...] // "string!"

//: [Next](@next)
