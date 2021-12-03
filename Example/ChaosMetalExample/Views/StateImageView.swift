//
//  StateImageView.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct StateImageView: View {

    @Binding var viewModel: StateImageViewModel

    var body: some View {
        switch viewModel {
        case .idle:
            Text("No Image to display")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
        case .processing:
            Text("Image is processing...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
        case .ready(let image):
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error:
            Text("Invalid image")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray)
        }
    }
}

struct StateImageView_Previews: PreviewProvider {
    static var previews: some View {
        StateImageView(viewModel: .constant(.processing))
    }
}
