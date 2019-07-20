//: [Previous](@previous)

/*
 If you’ve always wanted to use some kind of
 inheritance mechanism for your structs,
 Swift 5.1 is going to make you very happy!
 
 Using the new KeyPath-based dynamic member
 lookup, you can implement some pseudo-inheritance,
 where a type inherits the API of another one 🎉
 
 (However, be careful, I’m definitely not
 advocating inheritance as a go-to solution 🙃)
 */
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

//: [Next](@next)
