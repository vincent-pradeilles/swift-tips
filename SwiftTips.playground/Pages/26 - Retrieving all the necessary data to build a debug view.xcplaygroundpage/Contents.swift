//: [Previous](@previous)

/*
 A debug view, from which any controller of an app can be
 instantiated and pushed on the navigation stack, has the
 potential to bring some real value to a development process.
 A requirement to build such a view is to have a list of all
 the classes from a given `Bundle` that inherit from
 `UIViewController`.
 With the following `extension`, retrieving
 this list becomes a piece of cake 🍰
 */

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

//: [Next](@next)
