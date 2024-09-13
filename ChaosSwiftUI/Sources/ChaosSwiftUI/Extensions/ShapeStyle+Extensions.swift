//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

extension ShapeStyle where Self == Color {
    public static var ripple: Color {
        Color(hex: 0xDDDDDD).opacity(0.2)
    }
}
