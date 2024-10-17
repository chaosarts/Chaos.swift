//
//  CAAnimationGroup.swift
//  ChaosAnimation
//
//  Created by Fu Lam Diep on 27.03.21.
//

import QuartzCore

public extension CABasicAnimation {

    static func animations (for object: NSObject, toValues values: [String: Any], configure: ((CABasicAnimation) -> Void)? = nil) -> [CABasicAnimation] {
        values.map({
            let animation = CABasicAnimation(keyPath: $0.key)

            configure?(animation)

            animation.fromValue = object.value(forKey: $0.key)
            animation.toValue = $0.value

            return animation
        })
    }
}
