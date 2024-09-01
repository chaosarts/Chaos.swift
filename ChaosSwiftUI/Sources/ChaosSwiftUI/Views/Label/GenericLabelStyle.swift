//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 25.08.24.
//

import SwiftUI

fileprivate struct GenericLabelStyle<Body>: LabelStyle where Body: View {

    let content: (Configuration) -> Body

    func makeBody(configuration: Configuration) -> Body {
        content(configuration)
    }
}

extension LabelStyle {
    public static func iconTitle(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some LabelStyle {
        GenericLabelStyle { configuration in
            HStack(alignment: alignment, spacing: spacing) {
                configuration.icon
                configuration.title
            }
        }
    }

    public static func titleIcon(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some LabelStyle {
        GenericLabelStyle { configuration in
            HStack(alignment: alignment, spacing: spacing) {
                configuration.title
                configuration.icon
            }
        }
    }
}
