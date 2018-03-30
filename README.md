# SwiftTips

The following is a collection of tips I find to be useful when working with the Swift language.

# Summary

* [Manufacturing cache-efficient versions of pure functions](#manufacturing-cache-efficient-versions-of-pure-functions)
* [Simplifying complex condition with pattern matching](#simplifying-complex-condition-with-pattern-matching)
* [Easily generating arrays of data](#easily-generating-arrays-of-data)
* [Using @autoclosure for cleaner call sites](#using-autoclosure-for-cleaner-call-sites)
* [Observing new and old value with RxSwift](#observing-new-and-old-value-with-rxswift)
* [Implicit initialization from literal values](#implicit-initialization-from-literal-values)
* [Achieving systematic validation of data](#achieving-systematic-validation-of-data)
* [Implementing the builder pattern with keypaths](#implementing-the-builder-pattern-with-keypaths)
* [Storing functions rather than values](#storing-functions-rather-than-values)
* [Defining operators on function types](#defining-operators-on-function-types)
* [Typealiases for functions](#typealiases-for-functions)
* [Encapsulating state within a function](#encapsulating-state-within-a-function)
* [Generating all cases for an Enum](#generating-all-cases-for-an-enum)
* [Using map on optional values](#using-map-on-optional-values)

# Tips

## Manufacturing cache-efficient versions of pure functions

By capturing a local variable in a returned closure, it is possible to manufacture cache-efficient versions of [pure functions](https://en.wikipedia.org/wiki/Pure_function). Be careful though, this trick only works with non-recursive function!

```swift
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

## Simplifying complex condition with pattern matching

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

let view = UIView()

extension UILabel {
    func with<T>(_ property: ReferenceWritableKeyPath<UILabel, T>, setTo value: T) -> UILabel {
        self[keyPath: property] = value
        return self
    }
}

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

The if-let syntax is a great way to deal with optional values in a safe manner, but at times is that prove to be just a little bit to cumbersome. In such cases, using the `Optional.map()` function is a nice way to achieve a shorter code while retaining safeness and readability.


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