//
//  Copyright © 2024 Fu Lam Diep <fulam.diep@gmail.com>
//

import SwiftUI

public struct GenericDisclosureGroupStyle<Content>: DisclosureGroupStyle where Content: View {

    private let content: (Configuration) -> Content

    public func makeBody(configuration: Configuration) -> some View {
        content(configuration)
    }
}
