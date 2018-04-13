# SwiftTips

The following is a collection of tips I find to be useful when working with the Swift language.

# Summary

* [#22 Using parallelism to speed-up `map()`](#using-parallelism-to-speed-up-map)
* [#21 Measuring execution time with minimum boilerplate](#measuring-execution-time-with-minimum-boilerplate)
* [#20 Running two pieces of code in parallel](#running-two-pieces-of-code-in-parallel)
* [#19 Making good use of #file, #line and #function](#making-good-use-of-file-line-and-function)
* [#18 Comparing Optionals through Conditional Conformance](#comparing-optionals-through-conditional-conformance)
* [#17 Safely subscripting a Collection](#safely-subscripting-a-collection)
* [#16 Easier String slicing using ranges](#easier-string-slicing-using-ranges)
* [#15 Concise syntax for sorting using a KeyPath](#concise-syntax-for-sorting-using-a-keypath)
* [#14 Manufacturing cache-efficient versions of pure functions](#manufacturing-cache-efficient-versions-of-pure-functions)
* [#13 Simplifying complex condition with pattern matching](#simplifying-complex-conditions-with-pattern-matching)
* [#12 Easily generating arrays of data](#easily-generating-arrays-of-data)
* [#11 Using @autoclosure for cleaner call sites](#using-autoclosure-for-cleaner-call-sites)
* [#10 Observing new and old value with RxSwift](#observing-new-and-old-value-with-rxswift)
* [#09 Implicit initialization from literal values](#implicit-initialization-from-literal-values)
* [#08 Achieving systematic validation of data](#achieving-systematic-validation-of-data)
* [#07 Implementing the builder pattern with keypaths](#implementing-the-builder-pattern-with-keypaths)
* [#06 Storing functions rather than values](#storing-functions-rather-than-values)
* [#05 Defining operators on function types](#defining-operators-on-function-types)
* [#04 Typealiases for functions](#typealiases-for-functions)
* [#03 Encapsulating state within a function](#encapsulating-state-within-a-function)
* [#02 Generating all cases for an Enum](#generating-all-cases-for-an-enum)
* [#01 Using map on optional values](#using-map-on-optional-values)

# Tips

## Using parallelism to speed-up `map()`

Almost all Apple devices able to run Swift code are powered by a multi-core CPU, consequently making a good use of parallelism is a great way to improve code performance. `map()` is a perfect candidate for such an optimization, because it is almost trivial to implement a parallel version.


```swift
import Foundation

extension Array {
    func parallelMap<T>(_ transform: (Element) -> T) -> [T] {
        let res = UnsafeMutablePointer<T>.allocate(capacity: count)
        
        DispatchQueue.concurrentPerform(iterations: count) { i in
            res[i] = transform(self[i])
        }
        
        let finalResult = Array<T>(UnsafeBufferPointer(start: res, count: count))
        res.deallocate(capacity: count)
        
        return finalResult
    }
}

let array = (0..<1_000).map { $0 }

func work(_ n: Int) -> Int {
    return (0..<n).reduce(0, +)
}

array.parallelMap { work($0) }
```

🚨 Make sure to only use `parallelMap()` when the `transform` function actually performs some costly computations. Otherwise performances will be systematically slower than using `map()` because of the multithreading overhead.

## Measuring execution time with minimum boilerplate

During development of a feature that performs some heavy computations, it can be helpful to measure just how much time a chunk of code takes to run. The `time()` function is a nice tool for this purpose, because of how simple it is to add and then to remove when it is no longer needed.

```swift
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
```

## Running two pieces of code in parallel

Concurrency is definitely one of those topics were the right encapsulation bears the potential to make your life so much easier. For instance, with this piece of code you can easily launch two computations in parallel, and have the results returned in a tuple.

```swift
import Foundation

func parallel<T, U>(_ left: @autoclosure () -> T, _ right: @autoclosure () -> U) -> (T, U) {
    var leftRes: T?
    var rightRes: U?
    
    DispatchQueue.concurrentPerform(iterations: 2, execute: { id in
        if id == 0 {
            leftRes = left()
        } else {
            rightRes = right()
        }
    })
    
    return (leftRes!, rightRes!)
}

let values = (1...100_000).map { $0 }

let results = parallel(values.map { $0 * $0 }, values.reduce(0, +))
```

## Making good use of \#file, \#line and \#function

Swift exposes three special variables `#file`, `#line` and `#function`, that are respectively set to the name of the current file, line and function. Those variables become very useful when writing custom logging functions or test predicates.

```swift
import Foundation

func log(_ message: String, _ file: String = #file, _ line: Int = #line, _ function: String = #function) {
    print("[\(file):\(line)] \(function) - \(message)")
}

func foo() {
    log("Hello world!")
}

foo() // [MyPlayground.playground:8] foo() - Hello world!
```

## Comparing Optionals through Conditional Conformance


Swift 4.1 has introduced a new feature called [Conditional Conformance](https://swift.org/blog/conditional-conformance/), which allows a type to implement a protocol only when its generic type also does. 

With this addition it becomes easy to let `Optional` implement `Comparable` only when `Wrapped` also implements `Comparable`:

```swift
import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        switch (lhs, rhs) {
        case let (lhs?, rhs?):
            return lhs < rhs
        case (nil, _?):
            return true // anything is greater than nil
        case (_?, nil):
            return false // nil in smaller than anything
        case (nil, nil):
            return true // nil is not smaller than itself
        }
    }
}

let data: [Int?] = [8, 4, 3, nil, 12, 4, 2, nil, -5]
data.sorted() // [nil, nil, Optional(-5), Optional(2), Optional(3), Optional(4), Optional(4), Optional(8), Optional(12)]
```

## Safely subscripting a Collection

Any attempt to access an `Array` beyond its bounds will result in a crash. While it's possible to write conditions such as `if index < array.count { array[index] }` in order to prevent such crashes, this approach will rapidly become cumbersome.

A great thing is that this condition can be encapsulated in a custom `subscript` that will work on any `Collection`:

```swift
import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let data = [1, 3, 4]

data[safe: 1] // Optional(3)
data[safe: 10] // nil
```

## Easier String slicing using ranges

Subscripting a string with a range can be very cumbersome in Swift 4. Let's face it, no one wants to write lines like `someString[index(startIndex, offsetBy: 0)..<index(startIndex, offsetBy: 10)]` on a regular basis. 

Luckily, with the addition of one clever extension, strings can be sliced as easily as arrays 🎉

```swift
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
```

## Concise syntax for sorting using a KeyPath

By using a `KeyPath` along with a	 generic type, a very clean and concise syntax for sorting data can be implemented:

```swift
import Foundation

extension Sequence {
    func sorted<T: Comparable>(by attribute: KeyPath<Element, T>) -> [Element] {
        return sorted(by: { $0[keyPath: attribute] < $1[keyPath: attribute] })
    }
}

let data = ["Some", "words", "of", "different", "lengths"]

data.sorted(by: \.count) // ["of", "Some", "words", "lengths", "different"]
```

If you like this syntax, make sure to checkout [KeyPathKit](https://github.com/vincent-pradeilles/KeyPathKit)!

## Manufacturing cache-efficient versions of pure functions

By capturing a local variable in a returned closure, it is possible to manufacture cache-efficient versions of [pure functions](https://en.wikipedia.org/wiki/Pure_function). Be careful though, this trick only works with non-recursive function!

```swift
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
```

## Simplifying complex conditions with pattern matching

When distinguishing between complex boolean conditions, using a `switch` statement along with pattern matching can be more readable than the classic series of `if {} else if {}`.

```swift
import Foundation

let expr1: Bool
let expr2: Bool
let expr3: Bool

if expr1 && !expr3 {
    functionA()
} else if !expr2 && expr3 {
    functionB()
} else if expr1 && !expr2 && expr3 {
    functionC()
}

switch (expr1, expr2, expr3) {
    
case (true, _, false):
    functionA()
case (_, false, true):
    functionB()
case (true, false, true):
    functionC()
default:
    break
}
```

## Easily generating arrays of data

Using `map()` on a range makes it easy to generate an array of data.

```swift
import Foundation

func randomInt() -> Int { return Int(arc4random()) }

let randomArray = (1...10).map { _ in randomInt() }
```

## Using @autoclosure for cleaner call sites

Using `@autoclosure` enables the compiler to automatically wrap an argument within a closure, thus allowing for a very clean syntax at call sites.

```swift
import UIKit

extension UIView {
    class func animate(withDuration duration: TimeInterval, _ animations: @escaping @autoclosure () -> Void) {
        UIView.animate(withDuration: duration, animations: animations)
    }
}

let view = UIView()

UIView.animate(withDuration: 0.3, view.backgroundColor = .orange)
```

## Observing new and old value with RxSwift

When working with RxSwift, it's very easy to observe both the current and previous value of an observable sequence by simply introducing a shift using `skip()`.

```swift
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
```

## Implicit initialization from literal values

Using protocols such as `ExpressibleByStringLiteral` it is possible to provide an `init` that will be automatically when a literal value is provided, allowing for nice and short syntax. This can be very helpful when writing mock or test data.

```swift
import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)!
    }
}

let url: URL = "http://www.google.fr"

NSURLConnection.canHandle(URLRequest(url: "http://www.google.fr"))
```

## Achieving systematic validation of data

Through some clever use of Swift `private` visibility it is possible to define a container that holds any untrusted value (such as a user input) from which the only way to retrieve the value is by making it successfully pass a validation test.

```swift
import Foundation

struct Untrusted<T> {
    private(set) var value: T
}

protocol Validator {
    associatedtype T
    static func validation(value: T) -> Bool
}

extension Validator {
    static func validate(untrusted: Untrusted<T>) -> T? {
        if self.validation(value: untrusted.value) {
            return untrusted.value
        } else {
            return nil
        }
    }
}

struct FrenchPhoneNumberValidator: Validator {
    static func validation(value: String) -> Bool {
       return (value.count) == 10 && CharacterSet(charactersIn: value).isSubset(of: CharacterSet.decimalDigits)
    }
}

let validInput = Untrusted(value: "0122334455")
let invalidInput = Untrusted(value: "0123")

FrenchPhoneNumberValidator.validate(untrusted: validInput) // returns "0122334455"
FrenchPhoneNumberValidator.validate(untrusted: invalidInput) // returns nil
```

## Implementing the builder pattern with keypaths

With the addition of keypaths in Swift 4, it is now possible to easily implement the builder pattern, that allows the developer to clearly separate the code that initializes a value from the code that uses it, without the burden of defining a factory method.

```swift
import UIKit

protocol With {}

extension With where Self: AnyObject {
    @discardableResult
    func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}

extension UIView: With {}

let view = UIView()

let label = UILabel()
    .with(\.textColor, setTo: .red)
    .with(\.text, setTo: "Foo")
    .with(\.textAlignment, setTo: .right)
    .with(\.layer.cornerRadius, setTo: 5)

view.addSubview(label)
```

## Storing functions rather than values

When a type stores values for the sole purpose of parametrizing its functions, it’s then possible to not store the values but directly the function, with no discernable difference at the call site.

```swift
import Foundation

struct MaxValidator {
    let max: Int
    let strictComparison: Bool
    
    func isValid(_ value: Int) -> Bool {
        return self.strictComparison ? value < self.max : value <= self.max
    }
}

struct MaxValidator2 {
    var isValid: (_ value: Int) -> Bool
    
    init(max: Int, strictComparison: Bool) {
        self.isValid = strictComparison ? { $0 < max } : { $0 <= max }
    }
}

MaxValidator(max: 5, strictComparison: true).isValid(5) // false
MaxValidator2(max: 5, strictComparison: false).isValid(5) // true
```

## Defining operators on function types

Functions are first-class citizen types in Swift, so it is perfectly legal to define operators for them.

```swift
import Foundation

let firstRange = { (0...3).contains($0) }
let secondRange = { (5...6).contains($0) }

func ||(_ lhs: @escaping (Int) -> Bool, _ rhs: @escaping (Int) -> Bool) -> (Int) -> Bool {
    return { value in
        return lhs(value) || rhs(value)
    }
}

(firstRange || secondRange)(2) // true
(firstRange || secondRange)(4) // false
(firstRange || secondRange)(6) // true
```

## Typealiases for functions

Typealiases are great to express function signatures in a more comprehensive manner, which then enables us to easily define functions that operate on them, resulting in a nice way to write and use some powerful API.

```swift
import Foundation

typealias RangeSet = (Int) -> Bool

func union(_ left: @escaping RangeSet, _ right: @escaping RangeSet) -> RangeSet {
    return { left($0) || right($0) }
}

let firstRange = { (0...3).contains($0) }
let secondRange = { (5...6).contains($0) }

let unionRange = union(firstRange, secondRange)

unionRange(2) // true
unionRange(4) // false
```

## Encapsulating state within a function

By returning a closure that captures a local variable, it's possible to encapsulate a mutable state within a function.

```swift
import Foundation

func counterFactory() -> () -> Int {
    var counter = 0
    
    return {
        counter += 1
        return counter
    }
}

let counter = counterFactory()

counter() // returns 1
counter() // returns 2
```

## Generating all cases for an Enum

Through some clever leveraging of how enums are stored in memory, it is possible to generate an array that contains all the possible cases of an enum. This can prove particularly useful when writing unit tests that consume random data.

```swift
import Foundation

enum MyEnum { case first; case second; case third; case fourth }

protocol EnumCollection: Hashable {
    static var allCases: [Self] { get }
}

extension EnumCollection {
    public static var allCases: [Self] {
        var i = 0
        return Array(AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: Self.self, capacity: 1) { $0.pointee }
            }
            if next.hashValue != i { return nil }
            i += 1
            return next
        })
    }
}

extension MyEnum: EnumCollection { }

MyEnum.allCases // [.first, .second, .third, .fourth]
```

## Using map on optional values

The if-let syntax is a great way to deal with optional values in a safe manner, but at times it can prove to be just a little bit to cumbersome. In such cases, using the `Optional.map()` function is a nice way to achieve a shorter code while retaining safeness and readability.


```swift
import UIKit

let date: Date? = Date() // or could be nil, doesn't matter
let formatter = DateFormatter()
let label = UILabel()

if let safeDate = date {
    label.text = formatter.string(from: safeDate)
}

label.text = date.map { return formatter.string(from: $0) }

label.text = date.map(formatter.string(from:)) // even shorter, tough less readable
```
