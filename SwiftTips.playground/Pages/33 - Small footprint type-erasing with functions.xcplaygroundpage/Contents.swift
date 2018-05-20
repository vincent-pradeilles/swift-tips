//: [Previous](@previous)

/*
 Seasoned Swift developers know it: a protocol with associated
 type (PAT) "can only be used as a generic constraint because
 it has Self or associated type requirements". When we really
 need to use a PAT to type a variable, the goto workaround is
 to use a [type-erased wrapper](https://academy.realm.io/posts/type-erased-wrappers-in-swift/).
 
 While this solution works perfectly, it requires a fair amount
 of boilerplate code. In instances where we are only interested
 in exposing one particular function of the PAT, a shorter
 approach using function types is possible.
 */

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

//: [Next](@next)
