//
//  File.swift
//  
//
//  Created by fu.lam.diep on 30.09.22.
//

import SwiftUI

public struct DataImage<Placeholder: View>: View {

    @Binding private var data: Data?

    private let url: URL?

    public let placeholder: () -> Placeholder

    public init(url: URL?, data: Binding<Data?>, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self._data = data
        self.placeholder = placeholder
    }

    public var body: some View {
        Group {
            if let data = data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
            } else {
                placeholder()
            }
        }
        .onAppear {
            if let url = url, data == nil {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    withAnimation {
                        DispatchQueue.main.async {
                            self.data = data
                        }
                    }
                }.resume()
            }
        }
    }
}
