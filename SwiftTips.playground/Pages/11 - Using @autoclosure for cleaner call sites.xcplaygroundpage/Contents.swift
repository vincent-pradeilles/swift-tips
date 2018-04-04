//: [Previous](@previous)

/*
 Using `@autoclosure` enables the compiler to automatically
 wrap an argument within a closure, thus allowing for a very clean syntax at call sites.
 */
import UIKit

extension UIView {
    class func animate(withDuration duration: TimeInterval, _ animations: @escaping @autoclosure () -> Void) {
        UIView.animate(withDuration: duration, animations: animations)
    }
}

let view = UIView()

UIView.animate(withDuration: 0.3, view.backgroundColor = .orange)

//: [Next](@next)
