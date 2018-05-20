//: [Previous](@previous)

/*
 UI components such as `UITableView` and `UICollectionView`
 rely on reuse identifiers in order to efficiently recycle
 the views they display. Often, those reuse identifiers
 take the form of a static hardcoded `String`, that will be
 used for every instance of their class.
 
 Through protocol-oriented programing, it's possible to avoid
 those hardcoded values, and instead use the name of the type
 as a reuse identifier.
 */

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

//: [Next](@next)
