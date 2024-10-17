//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 25.08.24.
//

import SwiftUI

public struct GenericLabelStyle<Body>: LabelStyle where Body: View {

    let content: (Configuration) -> Body

    public init(content: @escaping (Configuration) -> Body) {
        self.content = content
    }

    public func makeBody(configuration: Configuration) -> Body {
        content(configuration)
    }
}

extension LabelStyle where Self == GenericLabelStyle<LabelStyleConfiguration.Title> {
    public static func iconTitle(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some LabelStyle {
        GenericLabelStyle { configuration in
            HStack(alignment: alignment, spacing: spacing) {
                configuration.icon
                configuration.title
            }
        }
    }

    public static var iconTitle: some LabelStyle {
        iconTitle()
    }

    public static func titleIcon(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil) -> some LabelStyle {
        GenericLabelStyle { configuration in
            HStack(alignment: alignment, spacing: spacing) {
                configuration.title
                configuration.icon
            }
        }
    }

    public static var titleIcon: some LabelStyle {
        titleIcon()
    }
}
