//
//  CAAnimationBlockDelegate.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 25.02.21.
//

import QuartzCore

@objc public class CAInlineAnimationDelegate: NSObject, CAAnimationDelegate {

    private let start: ((CAAnimation) -> Void)?

    private let stop: ((CAAnimation, Bool) -> Void)?

    public init (start: ((CAAnimation) -> Void)? = nil, stop: ((CAAnimation, Bool) -> Void)? = nil) {
        self.start = start
        self.stop = stop
    }

    public func animationDidStart(_ anim: CAAnimation) {
        self.start?(anim)
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.stop?(anim, flag)
    }
}
