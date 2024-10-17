//
//  Copyright © 2023 Chrono24 GmbH. All rights reserved.
//

import CoreFoundation

extension CGAffineTransform {
    public init(from origin: CGRect, to target: CGRect) {
        let scale = CGSize(
            width: CGFloat(target.width / origin.width),
            height: CGFloat(-target.height / origin.height)
        )

        let translate = CGPoint(x: target.minX - origin.minX * scale.width,
                                y: target.minY - origin.minY * scale.height + target.height)

        self = CGAffineTransform.identity
            .scaledBy(x: scale.width, y: scale.height)
            .translatedBy(x: translate.x, y: translate.y)
    }

    public init<T>(minX: T, minY: T, maxX: T, maxY: T, to target: CGRect) where T: BinaryFloatingPoint {
        let minX =  CGFloat(minX)
        let minY =  CGFloat(minY)
        let maxX =  CGFloat(maxX)
        let maxY =  CGFloat(maxY)
        let origin = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        self.init(from: origin, to: target)
    }
}
