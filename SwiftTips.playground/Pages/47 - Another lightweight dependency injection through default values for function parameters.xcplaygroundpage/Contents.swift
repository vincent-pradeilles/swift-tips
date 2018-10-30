//: [Previous](@previous)

/*
 Dependency injection boils down to a simple idea: when an
 object requires a dependency, it shouldn't create it by
 itself, but instead it should be given a function that does
 it for him.
 
 Now the great thing with Swift is that, not only can a
 function take another function as a parameter, but that
 parameter can also be given a default value.
 
 When you combine both those features, you can end up with
 a dependency injection pattern that is both lightweight on
 boilerplate, but also type safe.
 */

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

//: [Next](@next)
