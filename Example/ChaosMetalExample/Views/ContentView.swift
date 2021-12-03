//
//  ContentView.swift
//  ChaosMetalExample
//
//  Created by Fu Lam Diep on 03.12.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var contentViewModel: ContentViewModel

    var body: some View {
        VStack {
            HStack {
                StateImageView(viewModel: $contentViewModel.gpuStateImageViewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(4/3, contentMode: .fit)
                StateImageView(viewModel: $contentViewModel.cpuStateImageViewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(4/3, contentMode: .fit)
            }

            Button("Start Processing", action: {
                contentViewModel.startProcessing()
            })
            .disabled(contentViewModel.isProcessing)
        }
    }

    public init(image: NSImage?) {
        contentViewModel = ContentViewModel(image: image)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(image: NSImage(named: NSImage.Name("ExampleImage")))
    }
}
