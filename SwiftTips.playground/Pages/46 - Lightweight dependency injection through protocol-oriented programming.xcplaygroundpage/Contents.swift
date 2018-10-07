//: [Previous](@previous)

/*
 Singletons are pretty bad. They make your architecture rigid
 and tightly coupled, which then results in your code being
 hard to test and refactor. Instead of using singletons, your
 code should rely on dependency injection, which is a much more
 architecturally sound approach.
 
 But singletons are so easy to use, and dependency injection
 requires us to do extra-work. So maybe, for simple situations,
 we could find an in-between solution?
 
 One possible solution is to rely on one of Swift's most know
 features: protocol-oriented programming. Using a `protocol`,
 we declare and access our dependency. We then store it in a
 private singleton, and perform the injection through an
 extension of said `protocol`.
 
 This way, our code will indeed be decoupled from its dependency,
 while at the same time keeping the boilerplate to a minimum.
 */

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

//: [Next](@next)
