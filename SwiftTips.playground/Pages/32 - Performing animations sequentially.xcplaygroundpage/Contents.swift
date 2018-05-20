//: [Previous](@previous)

/*
 `UIKit` exposes a very powerful and simple API to perform
 view animations. However, this API can become a little bit
 quirky to use when we want to perform animations sequentially,
 because it involves nesting closure within one another, which
 produces notoriously hard to maintain code.
 
 Nonetheless, it's possible to define a rather simple class,
 that will expose a really nicer API for this particular use case 👌
 */

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

//: [Next](@next)
