//
//  Button+Extensions.swift
//  Timer
//
//  Created by Fu Lam Diep on 31.08.24.
//

import SwiftUI

extension Button {
    public init<Title, Icon>(action: @escaping () -> Void, @ViewBuilder title: @escaping () -> Title, @ViewBuilder icon: @escaping () -> Icon)
    where Title: View, Icon: View, Label == SwiftUI.Label<Title, Icon> {
        self.init(action: action) {
            Label {
                title()
            } icon: {
                icon()
            }
        }
    }

    public init<Title, Icon>(_ title: Title, @ViewBuilder icon: @escaping () -> Icon, action: @escaping () -> Void)
    where Title: StringProtocol, Icon: View, Label == SwiftUI.Label<Text, Icon> {
        self.init(action: action) {
            Label {
                Text(title)
            } icon: {
                icon()
            }
        }
    }

    public init<Title>(_ title: Title, icon: Image, action: @escaping () -> Void)
    where Title: StringProtocol, Label == SwiftUI.Label<Text, Image> {
        self.init(action: action) {
            Label {
                Text(title)
            } icon: {
                icon
            }
        }
    }

    public init<Title>(_ title: Title, name: String, bundle: Bundle = .main, action: @escaping () -> Void)
    where Title: StringProtocol, Label == SwiftUI.Label<Text, Image> {
        self.init(action: action) {
            Label {
                Text(title)
            } icon: {
                Image(name, bundle: bundle)
            }
        }
    }

    public init<Title>(_ title: Title, systemName: String, action: @escaping () -> Void)
    where Title: StringProtocol, Label == SwiftUI.Label<Text, Image> {
        self.init(action: action) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemName)
            }
        }
    }
}
