# SwiftTips

The following is a collection of tips I find to be useful when working with the Swift language. More content is available on my [Twitter](https://twitter.com/v_pradeilles) account!

📣 NEW 📣 Swift Tips are now available on [YouTube](https://www.youtube.com/playlist?list=PLdXMqVQnoFleH3GSuTUpr3Fjzp1JMy-je)

# Summary

* [#57 Property Wrappers as Debugging Tools](#property-wrappers-as-debugging-tools)
* [#56 Localization through `String` interpolation](#localization-through-string-interpolation)
* [#55 Implementing pseudo-inheritance between `structs`](#implementing-pseudo-inheritance-between-structs)
* [#54 Composing `NSAttributedString` through a Function Builder](#composing-nsattributedstring-through-a-function-builder)
* [#53 Using `switch` and `if` as expressions](#using-switch-and-if-as-expressions)
* [#52 Avoiding double negatives within `guard` statements](#avoiding-double-negatives-within-guard-statements)
* [#51 Defining a custom `init` without loosing the compiler-generated one](#defining-a-custom-init-without-loosing-the-compiler-generated-one)
* [#50 Implementing a namespace through an empty `enum`](#implementing-a-namespace-through-an-empty-enum)
* [#49 Using `Never` to represent impossible code paths](#using-never-to-represent-impossible-code-paths)
* [#48 Providing a default value to a `Decodable` `enum`](#providing-a-default-value-to-a-decodable-enum)
* [#47 Another lightweight dependency injection through default values for function parameters](#another-lightweight-dependency-injection-through-default-values-for-function-parameters)
* [#46 Lightweight dependency injection through protocol-oriented programming](#lightweight-dependency-injection-through-protocol-oriented-programming)
* [#45 Getting rid of overabundant `[weak self]` and `guard`](#getting-rid-of-overabundant-weak-self-and-guard)
* [#44 Solving callback hell with function composition](#solving-callback-hell-with-function-composition)
* [#43 Transform an asynchronous function into a synchronous one](#transform-an-asynchronous-function-into-a-synchronous-one)
* [#42 Using KeyPaths instead of closures](#using-keypaths-instead-of-closures)
* [#41 Bringing some type-safety to a `userInfo` `Dictionary`](#bringing-some-type-safety-to-a-userinfo-dictionary)
* [#40 Lightweight data-binding for an MVVM implementation](#lightweight-data-binding-for-an-mvvm-implementation)
* [#39 Using `typealias` to its fullest](#using-typealias-to-its-fullest)
* [#38 Writing an interruptible overload of `forEach`](#writing-an-interruptible-overload-of-foreach)
* [#37 Optimizing the use of `reduce()`](#optimizing-the-use-of-reduce)
* [#36 Avoiding hardcoded reuse identifiers](#avoiding-hardcoded-reuse-identifiers)
* [#35 Defining a union type](#defining-a-union-type)
* [#34 Asserting that classes have associated NIBs and vice-versa](#asserting-that-classes-have-associated-nibs-and-vice-versa)
* [#33 Small footprint type-erasing with functions](#small-footprint-type-erasing-with-functions)
* [#32 Performing animations sequentially](#performing-animations-sequentially)
* [#31 Debouncing a function call](#debouncing-a-function-call)
* [#30 Providing useful operators for `Optional` booleans](#providing-useful-operators-for-optional-booleans)
* [#29 Removing duplicate values from a `Sequence`](#removing-duplicate-values-from-a-sequence)
* [#28 Shorter syntax to deal with optional strings](#shorter-syntax-to-deal-with-optional-strings)
* [#27 Encapsulating background computation and UI update](#encapsulating-background-computation-and-ui-update)
* [#26 Retrieving all the necessary data to build a debug view](#retrieving-all-the-necessary-data-to-build-a-debug-view)
* [#25 Defining a function to map over dictionaries](#defining-a-function-to-map-over-dictionaries)
* [#24 A shorter syntax to remove `nil` values](#a-shorter-syntax-to-remove-nil-values)
* [#23 Dealing with expirable values](#dealing-with-expirable-values)
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

## Property Wrappers as Debugging Tools

Property Wrappers allow developers to wrap properties with specific behaviors, that will be seamlessly triggered whenever the properties are accessed.

While their primary use case is to implement business logic within our apps, it's also possible to use Property Wrappers as debugging tools!

For example, we could build a wrapper called `@History`, that would be added to a property while debugging and would keep track of all the values set to this property.

```swift
import Foundation

@propertyWrapper
struct History<Value> {
    private var value: Value
    private(set) var history: [Value] = []

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get { value }

        set {
            history.append(value)
            value = newValue
        }
    }
    
    var projectedValue: Self {
        return self
    }
}

// We can then decorate our business code
// with the `@History` wrapper
struct User {
    @History var name: String = ""
}

var user = User()

// All the existing call sites will still
// compile, without the need for any change
user.name = "John"
user.name = "Jane"

// But now we can also access an history of
// all the previous values!
user.$name.history // ["", "John"]
```

## Localization through `String` interpolation

Swift 5 gave us the possibility to define our own custom `String` interpolation methods.

This feature can be used to power many use cases, but there is one that is guaranteed to make sense in most projects: localizing user-facing strings.

```swift
import Foundation

extension String.StringInterpolation {
    mutating func appendInterpolation(localized key: String, _ args: CVarArg...) {
        let localized = String(format: NSLocalizedString(key, comment: ""), arguments: args)
        appendLiteral(localized)
    }
}


/*
 Let's assume that this is the content of our Localizable.strings:
 
 "welcome.screen.greetings" = "Hello %@!";
 */

let userName = "John"
print("\(localized: "welcome.screen.greetings", userName)") // Hello John!
```

## Implementing pseudo-inheritance between `structs`

If you’ve always wanted to use some kind of inheritance mechanism for your structs, Swift 5.1 is going to make you very happy!

Using the new KeyPath-based dynamic member lookup, you can implement some pseudo-inheritance, where a type inherits the API of another one 🎉

(However, be careful, I’m definitely not advocating inheritance as a go-to solution 🙃)

```swift
import Foundation

protocol Inherits {
    associatedtype SuperType
    
    var `super`: SuperType { get }
}

extension Inherits {
    subscript<T>(dynamicMember keyPath: KeyPath<SuperType, T>) -> T {
        return self.`super`[keyPath: keyPath]
    }
}

struct Person {
    let name: String
}

@dynamicMemberLookup
struct User: Inherits {
    let `super`: Person
    
    let login: String
    let password: String
}

let user = User(super: Person(name: "John Appleseed"), login: "Johnny", password: "1234")

user.name // "John Appleseed"
user.login // "Johnny"
```

## Composing `NSAttributedString` through a Function Builder

Swift 5.1 introduced Function Builders: a great tool for building custom DSL syntaxes, like SwiftUI. However, one doesn't need to be building a full-fledged DSL in order to leverage them.

For example, it's possible to write a simple Function Builder, whose job will be to compose together individual instances of `NSAttributedString` through a nicer syntax than the standard API.

```swift
import UIKit

@_functionBuilder
class NSAttributedStringBuilder {
    static func buildBlock(_ components: NSAttributedString...) -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")
        
        return components.reduce(into: result) { (result, current) in result.append(current) }
    }
}

extension NSAttributedString {
    class func composing(@NSAttributedStringBuilder _ parts: () -> NSAttributedString) -> NSAttributedString {
        return parts()
    }
}

let result = NSAttributedString.composing {
    NSAttributedString(string: "Hello",
                       attributes: [.font: UIFont.systemFont(ofSize: 24),
                                    .foregroundColor: UIColor.red])
    NSAttributedString(string: " world!",
                       attributes: [.font: UIFont.systemFont(ofSize: 20),
                                    .foregroundColor: UIColor.orange])
}
```

## Using `switch` and `if` as expressions

Contrary to other languages, like Kotlin, Swift does not allow `switch` and `if` to be used as expressions. Meaning that the following code is not valid Swift:

```swift
let constant = if condition {
                  someValue
               } else {
                  someOtherValue
               }
```

A common solution to this problem is to wrap the `if` or `switch` statement within a closure, that will then be immediately called. While this approach does manage to achieve the desired goal, it makes for a rather poor syntax.

To avoid the ugly trailing `()` and improve on the readability, you can define a `resultOf` function, that will serve the exact same purpose, in a more elegant way.

```swift
import Foundation

func resultOf<T>(_ code: () -> T) -> T {
    return code()
}

let randomInt = Int.random(in: 0...3)

let spelledOut: String = resultOf {
    switch randomInt {
    case 0:
        return "Zero"
    case 1:
        return "One"
    case 2:
        return "Two"
    case 3:
        return "Three"
    default:
        return "Out of range"
    }
}

print(spelledOut)
```

## Avoiding double negatives within `guard` statements

A `guard` statement is a very convenient way for the developer to assert that a condition is met, in order for the execution of the program to keep going.

However, since the body of a `guard` statement is meant to be executed when the condition evaluates to `false`, the use of the negation (`!`) operator within the condition of a `guard` statement can make the code hard to read, as it becomes a double negative.

A nice trick to avoid such double negatives is to encapsulate the use of the `!` operator within a new property or function, whose name does not include a negative.

```swift
import Foundation

extension Collection {
    var hasElements: Bool {
        return !isEmpty
    }
}

let array = Bool.random() ? [1, 2, 3] : []

guard array.hasElements else { fatalError("array was empty") }

print(array)
```

## Defining a custom `init` without loosing the compiler-generated one

It's common knowledge for Swift developers that, when you define a `struct`, the compiler is going to automatically generate a memberwise `init` for you. That is, unless you also define an `init` of your own. Because then, the compiler won't generate any memberwise `init`.

Yet, there are many instances where we might enjoy the opportunity to get both. As it turns out, this goal is quite easy to achieve: you just need to define your own `init` in an `extension` rather than inside the type definition itself.

```swift
import Foundation

struct Point {
    let x: Int
    let y: Int
}

extension Point {
    init() {
        x = 0
        y = 0
    }
}

let usingDefaultInit = Point(x: 4, y: 3)
let usingCustomInit = Point()
```

## Implementing a namespace through an empty `enum`

Swift does not really have an out-of-the-box support of namespaces. One could argue that a Swift module can be seen as a namespace, but creating a dedicated Framework for this sole purpose can legitimately be regarded as overkill.

Some developers have taken the habit to use a `struct` which only contains `static` fields to implement a namespace. While this does the job, it requires us to remember to implement an empty `private` `init()`, because it wouldn't make sense for such a `struct` to be instantiated.

It's actually possible to take this approach one step further, by replacing the `struct` with an `enum`. While it might seem weird to have an `enum` with no `case`, it's actually a [very idiomatic way](https://github.com/apple/swift/blob/a4230ab2ad37e37edc9ed86cd1510b7c016a769d/stdlib/public/core/Unicode.swift#L918) to declare a type that cannot be instantiated.

```swift
import Foundation

enum NumberFormatterProvider {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingIncrement = 0.01
        return formatter
    }
    
    static var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }
}

NumberFormatterProvider() // ❌ impossible to instantiate by mistake

NumberFormatterProvider.currencyFormatter.string(from: 2.456) // $2.46
NumberFormatterProvider.decimalFormatter.string(from: 2.456) // 2,456
```

## Using `Never` to represent impossible code paths

`Never` is quite a peculiar type in the Swift Standard Library: it is defined as an empty enum `enum Never { }`.

While this might seem odd at first glance, it actually yields a very interesting property: it makes it a type that cannot be constructed (i.e. it possesses no instances).

This way, `Never` can be used as a generic parameter to let the compiler know that a particular feature will not be used.

```swift
import Foundation

enum Result<Value, Error> {
    case success(value: Value)
    case failure(error: Error)
}

func willAlwaysSucceed(_ completion: @escaping ((Result<String, Never>) -> Void)) {
    completion(.success(value: "Call was successful"))
}

willAlwaysSucceed( { result in
    switch result {
    case .success(let value):
        print(value)
    // the compiler knows that the `failure` case cannot happen
    // so it doesn't require us to handle it.
    }
})
```

## Providing a default value to a `Decodable` `enum`

Swift's `Codable` framework does a great job at seamlessly decoding entities from a JSON stream. However, when we integrate web-services, we are sometimes left to deal with JSONs that require behaviors that `Codable` does not provide out-of-the-box.

For instance, we might have a string-based or integer-based `enum`, and be required to set it to a default value when the data found in the JSON does not match any of its cases. 

We might be tempted to implement this via an extensive `switch` statement over all the possible cases, but there is a much shorter alternative through the initializer `init?(rawValue:)`:

```swift
import Foundation

enum State: String, Decodable {
    case active
    case inactive
    case undefined
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        
        self = State(rawValue: decodedString) ?? .undefined
    }
}

let data = """
["active", "inactive", "foo"]
""".data(using: .utf8)!

let decoded = try! JSONDecoder().decode([State].self, from: data)

print(decoded) // [State.active, State.inactive, State.undefined]
```

## Another lightweight dependency injection through default values for function parameters

Dependency injection boils down to a simple idea: when an object requires a dependency, it shouldn't create it by itself, but instead it should be given a function that does it for him.

Now the great thing with Swift is that, not only can a function take another function as a parameter, but that parameter can also be given a default value.

When you combine both those features, you can end up with a dependency injection pattern that is both lightweight on boilerplate, but also type safe.

```swift
import Foundation

protocol Service {
    func call() -> String
}

class ProductionService: Service {
    func call() -> String {
        return "This is the production"
    }
}

class MockService: Service {
    func call() -> String {
        return "This is a mock"
    }
}

typealias Provider<T> = () -> T

class Controller {
    
    let service: Service
    
    init(serviceProvider: Provider<Service> = { return ProductionService() }) {
        self.service = serviceProvider()
    }
    
    func work() {
        print(service.call())
    }
}

let productionController = Controller()
productionController.work() // prints "This is the production"

let mockedController = Controller(serviceProvider: { return MockService() })
mockedController.work() // prints "This is a mock"
```

## Lightweight dependency injection through protocol-oriented programming

Singletons are pretty bad. They make your architecture rigid and tightly coupled, which then results in your code being hard to test and refactor. Instead of using singletons, your code should rely on dependency injection, which is a much more architecturally sound approach.

But singletons are so easy to use, and dependency injection requires us to do extra-work. So maybe, for simple situations, we could find an in-between solution?

One possible solution is to rely on one of Swift's most know features: protocol-oriented programming. Using a `protocol`, we declare and access our dependency. We then store it in a private singleton, and perform the injection through an extension of said `protocol`.

This way, our code will indeed be decoupled from its dependency, while at the same time keeping the boilerplate to a minimum.

```swift
import Foundation

protocol Formatting {
    var formatter: NumberFormatter { get }
}

private let sharedFormatter: NumberFormatter = {
    let sharedFormatter = NumberFormatter()
    sharedFormatter.numberStyle = .currency
    return sharedFormatter
}()

extension Formatting {
    var formatter: NumberFormatter { return sharedFormatter }
}

class ViewModel: Formatting {
    var displayableAmount: String?
    
    func updateDisplay(to amount: Double) {
        displayableAmount = formatter.string(for: amount)
    }
}

let viewModel = ViewModel()

viewModel.updateDisplay(to: 42000.45)
viewModel.displayableAmount // "$42,000.45"
``` 

## Getting rid of overabundant `[weak self]` and `guard`

Callbacks are a part of almost all iOS apps, and as frameworks such as `RxSwift` keep gaining in popularity, they become ever more present in our codebase.

Seasoned Swift developers are aware of the potential memory leaks that `@escaping` callbacks can produce, so they make real sure to always use `[weak self]`, whenever they need to use `self` inside such a context. And when they need to have `self` be non-optional, they then add a `guard` statement along.

Consequently, this syntax of a `[weak self]` followed by a `guard` rapidly tends to appear everywhere in the codebase. The good thing is that, through a little protocol-oriented trick, it's actually possible to get rid of this tedious syntax, without loosing any of its benefits!

```swift
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

protocol Weakifiable: class { }

extension Weakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            
            code(arg, self)
        }
    }
}

extension NSObject: Weakifiable { }

class Producer: NSObject {
    
    deinit {
        print("deinit Producer")
    }
    
    private var handler: (Int) -> Void = { _ in }
    
    func register(handler: @escaping (Int) -> Void) {
        self.handler = handler
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { self.handler(42) })
    }
}

class Consumer: NSObject {
    
    deinit {
        print("deinit Consumer")
    }
    
    let producer = Producer()
    
    func consume() {
        producer.register(handler: weakify { result, strongSelf in
            strongSelf.handle(result)
        })
    }
    
    private func handle(_ result: Int) {
        print("🎉 \(result)")
    }
}

var consumer: Consumer? = Consumer()

consumer?.consume()

DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { consumer = nil })

// This code prints:
// 🎉 42
// deinit Consumer
// deinit Producer
```

## Solving callback hell with function composition

Asynchronous functions are a big part of iOS APIs, and most developers are familiar with the challenge they pose when one needs to sequentially call several asynchronous APIs.

This often results in callbacks being nested into one another, a predicament often referred to as callback hell.

Many third-party frameworks are able to tackle this issue, for instance [RxSwift](https://github.com/ReactiveX/RxSwift) or [PromiseKit](https://github.com/mxcl/PromiseKit). Yet, for simple instances of the problem, there is no need to use such big guns, as it can actually be solved with simple function composition.

```swift
import Foundation

typealias CompletionHandler<Result> = (Result?, Error?) -> Void

infix operator ~>: MultiplicationPrecedence

func ~> <T, U>(_ first: @escaping (CompletionHandler<T>) -> Void, _ second: @escaping (T, CompletionHandler<U>) -> Void) -> (CompletionHandler<U>) -> Void {
    return { completion in
        first({ firstResult, error in
            guard let firstResult = firstResult else { completion(nil, error); return }
            
            second(firstResult, { (secondResult, error) in
                completion(secondResult, error)
            })
        })
    }
}

func ~> <T, U>(_ first: @escaping (CompletionHandler<T>) -> Void, _ transform: @escaping (T) -> U) -> (CompletionHandler<U>) -> Void {
    return { completion in
        first({ result, error in
            guard let result = result else { completion(nil, error); return }
            
            completion(transform(result), nil)
        })
    }
}

func service1(_ completionHandler: CompletionHandler<Int>) {
    completionHandler(42, nil)
}

func service2(arg: String, _ completionHandler: CompletionHandler<String>) {
    completionHandler("🎉 \(arg)", nil)
}

let chainedServices = service1
	~> { int in return String(int / 2) }
	~> service2

chainedServices({ result, _ in
    guard let result = result else { return }
    
    print(result) // Prints: 🎉 21
})
```

## Transform an asynchronous function into a synchronous one

Asynchronous functions are a great way to deal with future events without blocking a thread. Yet, there are times where we would like them to behave in exactly such a blocking way.

Think about writing unit tests and using mocked network calls. You will need to add complexity to your test in order to deal with asynchronous functions, whereas synchronous ones would be much easier to manage.

Thanks to Swift proficiency in the functional paradigm, it is possible to write a function whose job is to take an asynchronous function and transform it into a synchronous one.

```swift
import Foundation

func makeSynchrone<A, B>(_ asyncFunction: @escaping (A, (B) -> Void) -> Void) -> (A) -> B {
    return { arg in
        let lock = NSRecursiveLock()
        
        var result: B? = nil
        
        asyncFunction(arg) {
            result = $0
            lock.unlock()
        }
        
        lock.lock()
        
        return result!
    }
}

func myAsyncFunction(arg: Int, completionHandler: (String) -> Void) {
    completionHandler("🎉 \(arg)")
}

let syncFunction = makeSynchrone(myAsyncFunction)

print(syncFunction(42)) // prints 🎉 42
```

## Using KeyPaths instead of closures

Closures are a great way to interact with generic APIs, for instance APIs that allow to manipulate data structures through the use of generic functions, such as `filter()` or `sorted()`.

The annoying part is that closures tend to clutter your code with many instances of `{`, `}` and `$0`, which can quickly undermine its readably.

A nice alternative for a cleaner syntax is to use a `KeyPath` instead of a closure, along with an operator that will deal with transforming the provided `KeyPath` in a closure.

```swift
import Foundation

prefix operator ^

prefix func ^ <Element, Attribute>(_ keyPath: KeyPath<Element, Attribute>) -> (Element) -> Attribute {
    return { element in element[keyPath: keyPath] }
}

struct MyData {
    let int: Int
    let string: String
}

let data = [MyData(int: 2, string: "Foo"), MyData(int: 4, string: "Bar")]

data.map(^\.int) // [2, 4]
data.map(^\.string) // ["Foo", "Bar"]
```

## Bringing some type-safety to a `userInfo` `Dictionary`

Many iOS APIs still rely on a `userInfo` `Dictionary` to handle use-case specific data. This `Dictionary` usually stores untyped values, and is declared as follows: `[String: Any]` (or sometimes `[AnyHashable: Any]`.

Retrieving data from such a structure will involve some conditional casting (via the `as?` operator), which is prone to both errors and repetitions. Yet, by introducing a custom `subscript`, it's possible to encapsulate all the tedious logic, and end-up with an easier and more robust API.

```swift
import Foundation

typealias TypedUserInfoKey<T> = (key: String, type: T.Type)

extension Dictionary where Key == String, Value == Any {
    subscript<T>(_ typedKey: TypedUserInfoKey<T>) -> T? {
        return self[typedKey.key] as? T
    }
}

let userInfo: [String : Any] = ["Foo": 4, "Bar": "forty-two"]

let integerTypedKey = TypedUserInfoKey(key: "Foo", type: Int.self)
let intValue = userInfo[integerTypedKey] // returns 4
type(of: intValue) // returns Int?

let stringTypedKey = TypedUserInfoKey(key: "Bar", type: String.self)
let stringValue = userInfo[stringTypedKey] // returns "forty-two"
type(of: stringValue) // returns String?
```

## Lightweight data-binding for an MVVM implementation

MVVM is a great pattern to separate business logic from presentation logic. The main challenge to make it work, is to define a mechanism for the presentation layer to be notified of model updates.

[RxSwift](https://github.com/ReactiveX/RxSwift) is a perfect choice to solve such a problem. Yet, some developers don't feel confortable with leveraging a third-party library for such a central part of their architecture.

For those situation, it's possible to define a lightweight `Variable` type, that will make the MVVM pattern very easy to use!

```swift
import Foundation

class Variable<Value> {
    var value: Value {
        didSet {
            onUpdate?(value)
        }
    }
    
    var onUpdate: ((Value) -> Void)? {
        didSet {
            onUpdate?(value)
        }
    }
    
    init(_ value: Value, _ onUpdate: ((Value) -> Void)? = nil) {
        self.value = value
        self.onUpdate = onUpdate
        self.onUpdate?(value)
    }
}

let variable: Variable<String?> = Variable(nil)

variable.onUpdate = { data in
    if let data = data {
        print(data)
    }
}

variable.value = "Foo"
variable.value = "Bar"

// prints:
// Foo
// Bar
```

## Using `typealias` to its fullest

The keyword `typealias` allows developers to give a new name to an already existing type. For instance, Swift defines `Void` as a `typealias` of `()`, the empty tuple. 

But a less known feature of this mechanism is that it allows to assign concrete types for generic parameters, or to rename them. This can help make the semantics of generic types much clearer, when used in specific use cases.

```swift
import Foundation

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

typealias Result<Value> = Either<Value, Error>

typealias IntOrString = Either<Int, String>
```

## Writing an interruptible overload of `forEach`

Iterating through objects via the `forEach(_:)` method is a great alternative to the classic `for` loop, as it allows our code to be completely oblivious of the iteration logic. One limitation, however, is that `forEach(_:)` does not allow to stop the iteration midway.

Taking inspiration from the [Objective-C implementation](https://developer.apple.com/documentation/foundation/nsarray/1415846-enumerateobjectsusingblock), we can write an overload that will allow the developer to stop the iteration, if needed.

```swift
import Foundation

extension Sequence {
    func forEach(_ body: (Element, _ stop: inout Bool) throws -> Void) rethrows {
        var stop = false
        for element in self {
            try body(element, &stop)
            
            if stop {
                return
            }
        }
    }
}

["Foo", "Bar", "FooBar"].forEach { element, stop in
    print(element)
    stop = (element == "Bar")
}

// Prints:
// Foo
// Bar
```

## Optimizing the use of `reduce()`

Functional programing is a great way to simplify a codebase. For instance, `reduce` is an alternative to the classic `for` loop, without most the boilerplate. Unfortunately, simplicity often comes at the price of performance.

Consider that you want to remove duplicate values from a `Sequence`. While `reduce()` is a perfectly fine way to express this computation, the performance will be sub optimal, because of all the unnecessary `Array` copying that will happen every time its closure gets called.

That's when `reduce(into:_:)` comes into play. This version of `reduce` leverages the capacities of copy-on-write type (such as `Array` or `Dictionnary`) in order to avoid unnecessary copying, which results in a great performance boost.

```swift
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
```

## Avoiding hardcoded reuse identifiers

UI components such as `UITableView` and `UICollectionView` rely on reuse identifiers in order to efficiently recycle the views they display. Often, those reuse identifiers take the form of a static hardcoded `String`, that will be used for every instance of their class.

Through protocol-oriented programing, it's possible to avoid those hardcoded values, and instead use the name of the type as a reuse identifier.

```swift
import Foundation
import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }

extension UITableView {
    func register<T: UITableViewCell>(_ class: T.Type) {
        register(`class`, forCellReuseIdentifier: T.reuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

class MyCell: UITableViewCell { }

let tableView = UITableView()

tableView.register(MyCell.self)
let myCell: MyCell = tableView.dequeueReusableCell(for: [0, 0])
```

## Defining a union type

The C language has a construct called `union`, that allows a single variable to hold values from different types. While Swift does not provide such a construct, it provides enums with associated values, which allows us to define a type called `Either` that implements a `union` of two types.

```swift
import Foundation

enum Either<A, B> {
    case left(A)
    case right(B)
    
    func either(ifLeft: ((A) -> Void)? = nil, ifRight: ((B) -> Void)? = nil) {
        switch self {
        case let .left(a):
            ifLeft?(a)
        case let .right(b):
            ifRight?(b)
        }
    }
}

extension Bool { static func random() -> Bool { return arc4random_uniform(2) == 0 } }

var intOrString: Either<Int, String> = Bool.random() ? .left(2) : .right("Foo")

intOrString.either(ifLeft: { print($0 + 1) }, ifRight: { print($0 + "Bar") })
```

If you're interested by this kind of data structure, I strongly recommend that you learn more about [Algebraic Data Types](https://en.wikipedia.org/wiki/Algebraic_data_type).

## Asserting that classes have associated NIBs and vice-versa

Most of the time, when we create a `.xib` file, we give it the same name as its associated class. From that, if we later refactor our code and rename such a class, we run the risk of forgetting to rename the associated `.xib`.

While the error will often be easy to catch, if the `.xib` is used in a remote section of its app, it might go unnoticed for sometime. Fortunately it's possible to build custom test predicates that will assert that 1) for a given class, there exists a `.nib` with the same name in a given `Bundle`, 2) for all the `.nib` in a given `Bundle`, there exists a class with the same name.

```swift
import XCTest

public func XCTAssertClassHasNib(_ class: AnyClass, bundle: Bundle, file: StaticString = #file, line: UInt = #line) {
    let associatedNibURL = bundle.url(forResource: String(describing: `class`), withExtension: "nib")
    
    XCTAssertNotNil(associatedNibURL, "Class \"\(`class`)\" has no associated nib file", file: file, line: line)
}

public func XCTAssertNibHaveClasses(_ bundle: Bundle, file: StaticString = #file, line: UInt = #line) {
    guard let bundleName = bundle.infoDictionary?["CFBundleName"] as? String,
        let basePath = bundle.resourcePath,
        let enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: basePath),
                                                    includingPropertiesForKeys: nil,
                                                    options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants]) else { return }
    
    var nibFilesURLs = [URL]()
    
    for case let fileURL as URL in enumerator {
        if fileURL.pathExtension.uppercased() == "NIB" {
            nibFilesURLs.append(fileURL)
        }
    }
    
    nibFilesURLs.map { $0.lastPathComponent }
        .compactMap { $0.split(separator: ".").first }
        .map { String($0) }
        .forEach {
            let associatedClass: AnyClass? = bundle.classNamed("\(bundleName).\($0)")
            
            XCTAssertNotNil(associatedClass, "File \"\($0).nib\" has no associated class", file: file, line: line)
        }
}

XCTAssertClassHasNib(MyFirstTableViewCell.self, bundle: Bundle(for: AppDelegate.self))
XCTAssertClassHasNib(MySecondTableViewCell.self, bundle: Bundle(for: AppDelegate.self))
        
XCTAssertNibHaveClasses(Bundle(for: AppDelegate.self))
```

Many thanks [Benjamin Lavialle](https://www.linkedin.com/in/benjamin-lavialle-0a184140/) for coming up with the idea behind the second test predicate.

## Small footprint type-erasing with functions

Seasoned Swift developers know it: a protocol with associated type (PAT) "can only be used as a generic constraint because it has Self or associated type requirements". When we really need to use a PAT to type a variable, the goto workaround is to use a [type-erased wrapper](https://academy.realm.io/posts/type-erased-wrappers-in-swift/).

While this solution works perfectly, it requires a fair amount of boilerplate code. In instances where we are only interested in exposing one particular function of the PAT, a shorter approach using function types is possible.

```swift
import Foundation
import UIKit

protocol Configurable {
    associatedtype Model
    
    func configure(with model: Model)
}

typealias Configurator<Model> = (Model) -> ()

extension UILabel: Configurable {
    func configure(with model: String) {
        self.text = model
    }
}

let label = UILabel()
let configurator: Configurator<String> = label.configure

configurator("Foo")

label.text // "Foo"
```

## Performing animations sequentially

`UIKit` exposes a very powerful and simple API to perform view animations. However, this API can become a little bit quirky to use when we want to perform animations sequentially, because it involves nesting closure within one another, which produces notoriously hard to maintain code.

Nonetheless, it's possible to define a rather simple class, that will expose a really nicer API for this particular use case 👌

```swift
import Foundation
import UIKit

class AnimationSequence {
    typealias Animations = () -> Void
    
    private let current: Animations
    private let duration: TimeInterval
    private var next: AnimationSequence? = nil
    
    init(animations: @escaping Animations, duration: TimeInterval) {
        self.current = animations
        self.duration = duration
    }
    
    @discardableResult func append(animations: @escaping Animations, duration: TimeInterval) -> AnimationSequence {
        var lastAnimation = self
        while let nextAnimation = lastAnimation.next {
            lastAnimation = nextAnimation
        }
        lastAnimation.next = AnimationSequence(animations: animations, duration: duration)
        return self
    }
    
    func run() {
        UIView.animate(withDuration: duration, animations: current, completion: { finished in
            if finished, let next = self.next {
                next.run()
            }
        })
    }
}

var firstView = UIView()
var secondView = UIView()

firstView.alpha = 0
secondView.alpha = 0

AnimationSequence(animations: { firstView.alpha = 1.0 }, duration: 1)
            .append(animations: { secondView.alpha = 1.0 }, duration: 0.5)
            .append(animations: { firstView.alpha = 0.0 }, duration: 2.0)
            .run()
```

## Debouncing a function call

Debouncing is a very useful tool when dealing with UI inputs. Consider a search bar, whose content is used to query an API. It wouldn't make sense to perform a request for every character the user is typing, because as soon as a new character is entered, the result of the previous request has become irrelevant.

Instead, our code will perform much better if we "debounce" the API call, meaning that we will wait until some delay has passed, without the input being modified, before actually performing the call.

```swift
import Foundation

func debounced(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
    var workItem: DispatchWorkItem?
    
    return {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}

let debouncedPrint = debounced(delay: 1.0) { print("Action performed!") }

debouncedPrint()
debouncedPrint()
debouncedPrint()

// After a 1 second delay, this gets
// printed only once to the console:

// Action performed!
```

## Providing useful operators for `Optional` booleans

When we need to apply the standard boolean operators to `Optional` booleans, we often end up with a syntax unnecessarily crowded with unwrapping operations. By taking a cue from the world of [three-valued logics](https://en.wikipedia.org/wiki/Three-valued_logic), we can define a couple operators that make working with `Bool?` values much nicer. 

```swift
import Foundation

func && (lhs: Bool?, rhs: Bool?) -> Bool? {
    switch (lhs, rhs) {
    case (false, _), (_, false):
        return false
    case let (unwrapLhs?, unwrapRhs?):
        return unwrapLhs && unwrapRhs
    default:
        return nil
    }
}

func || (lhs: Bool?, rhs: Bool?) -> Bool? {
    switch (lhs, rhs) {
    case (true, _), (_, true):
        return true
    case let (unwrapLhs?, unwrapRhs?):
        return unwrapLhs || unwrapRhs
    default:
        return nil
    }
}

false && nil // false
true && nil // nil
[true, nil, false].reduce(true, &&) // false

nil || true // true
nil || false // nil
[true, nil, false].reduce(false, ||) // true
```

## Removing duplicate values from a `Sequence`

Transforming a `Sequence` in order to remove all the duplicate values it contains is a classic use case. To implement it, one could be tempted to transform the `Sequence` into a `Set`, then back to an `Array`. The downside with this approach is that it will not preserve the order of the sequence, which can definitely be a dealbreaker. Using `reduce()` it is possible to provide a concise implementation that preserves ordering:

```swift
import Foundation

extension Sequence where Element: Equatable {
    func duplicatesRemoved() -> [Element] {
        return reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
    }
}

let data = [2, 5, 2, 3, 6, 5, 2]

data.duplicatesRemoved() // [2, 5, 3, 6]
```

## Shorter syntax to deal with optional strings

Optional strings are very common in Swift code, for instance many objects from `UIKit` expose the text they display as a `String?`. Many times you will need to manipulate this data as an unwrapped `String`, with a default value set to the empty string for `nil` cases. 

While the nil-coalescing operator (e.g. `??`) is a perfectly fine way to a achieve this goal, defining a computed variable like `orEmpty` can help a lot in cleaning the syntax.

```swift
import Foundation
import UIKit

extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .some(let value):
            return value
        case .none:
            return ""
        }
    }
}

func doesNotWorkWithOptionalString(_ param: String) {
    // do something with `param`
}

let label = UILabel()
label.text = "This is some text."

doesNotWorkWithOptionalString(label.text.orEmpty)
```

## Encapsulating background computation and UI update

Every seasoned iOS developers knows it: objects from `UIKit` can only be accessed from the main thread. Any attempt to access them from a background thread is a guaranteed crash. 

Still, running a costly computation on the background, and then using it to update the UI can be a common pattern. 

In such cases you can rely on `asyncUI` to encapsulate all the boilerplate code.

```swift
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
```

## Retrieving all the necessary data to build a debug view

A debug view, from which any controller of an app can be instantiated and pushed on the navigation stack, has the potential to bring some real value to a development process. A requirement to build such a view is to have a list of all the classes from a given `Bundle` that inherit from `UIViewController`. With the following `extension`, retrieving this list becomes a piece of cake 🍰

```swift
import Foundation
import UIKit
import ObjectiveC

extension Bundle {
    func viewControllerTypes() -> [UIViewController.Type] {
        guard let bundlePath = self.executablePath else { return [] }
        
        var size: UInt32 = 0
        var rawClassNames: UnsafeMutablePointer<UnsafePointer<Int8>>!
        var parsedClassNames = [String]()
        
        rawClassNames = objc_copyClassNamesForImage(bundlePath, &size)
        
        for index in 0..<size {
            let className = rawClassNames[Int(index)]
            
            if let name = NSString.init(utf8String:className) as String?,
                NSClassFromString(name) is UIViewController.Type {
                parsedClassNames.append(name)
            }
        }
        
        return parsedClassNames
            .sorted()
            .compactMap { NSClassFromString($0) as? UIViewController.Type }
    }
}

// Fetch all view controller types in UIKit
Bundle(for: UIViewController.self).viewControllerTypes()
```

> I share the credit for this tip with [Benoît Caron](https://www.linkedin.com/in/benoît-caron-57530634/).

## Defining a function to map over dictionaries

**Update** As it turns out, `map` is actually a really bad name for this function, because it does not preserve composition of transformations, a property that is required to fit the [definition](https://en.wikipedia.org/wiki/Functor) of a real `map` function.

Surprisingly enough, the standard library doesn't define a `map()` function for dictionaries that allows to map both `keys` and `values` into a new `Dictionary`. Nevertheless, such a function can be helpful, for instance when converting data across different frameworks.

```swift
import Foundation

extension Dictionary {
    func map<T: Hashable, U>(_ transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        
        return result
    }
}

let data = [0: 5, 1: 6, 2: 7]
data.map { ("\($0)", $1 * $1) } // ["2": 49, "0": 25, "1": 36]
```

## A shorter syntax to remove `nil` values

Swift provides the function `compactMap()`, that can be used to remove `nil` values from a `Sequence` of optionals when calling it with an argument that just returns its parameter (i.e. `compactMap { $0 }`). Still, for such use cases it would be nice to get rid of the trailing closure.

The implementation isn't as straightforward as your usual `extension`, but once it has been written, the call site definitely gets cleaner 👌

```swift
import Foundation

protocol OptionalConvertible {
    associatedtype Wrapped
    func asOptional() -> Wrapped?
}

extension Optional: OptionalConvertible {
    func asOptional() -> Wrapped? {
        return self
    }
}

extension Sequence where Element: OptionalConvertible {
    func compacted() -> [Element.Wrapped] {
        return compactMap { $0.asOptional() }
    }
}

let data = [nil, 1, 2, nil, 3, 5, nil, 8, nil]
data.compacted() // [1, 2, 3, 5, 8]
```

## Dealing with expirable values

It might happen that your code has to deal with values that come with an expiration date. In a game, it could be a score multiplier that will only last for 30 seconds. Or it could be an authentication token for an API, with a 15 minutes lifespan. In both instances you can rely on the type `Expirable` to encapsulate the expiration logic.

```swift
import Foundation

struct Expirable<T> {
    private var innerValue: T
    private(set) var expirationDate: Date
    
    var value: T? {
        return hasExpired() ? nil : innerValue
    }
    
    init(value: T, expirationDate: Date) {
        self.innerValue = value
        self.expirationDate = expirationDate
    }
    
    init(value: T, duration: Double) {
        self.innerValue = value
        self.expirationDate = Date().addingTimeInterval(duration)
    }
    
    func hasExpired() -> Bool {
        return expirationDate < Date()
    }
}

let expirable = Expirable(value: 42, duration: 3)

sleep(2)
expirable.value // 42
sleep(2)
expirable.value // nil
```

> I share the credit for this tip with [Benoît Caron](https://www.linkedin.com/in/benoît-caron-57530634/).

## Using parallelism to speed-up `map()`

Almost all Apple devices able to run Swift code are powered by a multi-core CPU, consequently making a good use of parallelism is a great way to improve code performance. `map()` is a perfect candidate for such an optimization, because it is almost trivial to define a parallel implementation.


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

🚨 Make sure to only use `parallelMap()` when the `transform` function actually performs some costly computations. Otherwise performances will be systematically slower than using `map()`, because of the multithreading overhead.

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

🚨 The Swift compiler **does not** perform OS availability checks on properties referenced by keypaths. Any attempt to use a `KeyPath` for an unavailable property will result in a runtime crash.

> I share the credit for this tip with [Marion Curtil](https://www.linkedin.com/in/marion-curtil-1a478970/).

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

> ⚠️ Since Swift 4.2, `allCases` can now be synthesized at compile-time by simply conforming to the protocol `CaseIterable`. The implementation below should no longer be used in production code.

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
