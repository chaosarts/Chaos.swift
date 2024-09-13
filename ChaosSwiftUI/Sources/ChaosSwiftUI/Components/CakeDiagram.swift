//
//  File.swift
//  
//
//  Created by Fu Lam Diep on 06.09.24.
//

import SwiftUI

public struct CakeDiagram<Value, Wedge>: View where Value: BinaryFloatingPoint, Wedge: View {

    let values: [Value]

    var total: Value {
        values.reduce(0) { partialResult, value in
            partialResult + value
        }
    }

    let startAngle: Angle

    let wedgeShape: (Array<Value>.Index, WedgeShape) -> Wedge

    init(values: [Value],
         startAngle: Angle = .north,
         wedgeShape: @escaping (Array<BinaryFloatingPoint>.Index, WedgeShape) -> Wedge) {
        self.values = values
        self.startAngle = startAngle
        self.wedgeShape = wedgeShape
    }

    public var body: some View {
        ZStack {
            let angles = self.angles(for: values)
            ForEach(angles.indices, id: \.self) { index in
                let angle = angles[index]
                let nextIndex = (index + 1) % angles.count
                wedgeShape(index, WedgeShape(from: angle, to: angles[nextIndex], innerRadius: 100))
            }
        }
    }

    func angles(for values: [Value]) -> [Angle] {
        let total = total
        var angles = [startAngle]
        for value in values {
            let percentage = Double(exactly: value / total)!
            angles.append(angles.last! + .degrees(percentage * 360))
        }
        return angles
    }
}

#Preview {
    let colors: [Color] = [.red, .blue, .green, .yellow]
    return CakeDiagram(values: [4, 8, 10, 13], startAngle: .north) { index, shape in
        shape.foregroundStyle(colors[index % colors.count])
    }
}

#Preview {
    NavigationView {
        ZStack {

            VStack(alignment: .leading) {
                Text("Lorem ipsum dolor")
                Text("ipsum dolor")
            }
            .redacted(reason: .placeholder)
            .background {
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .green, location: 1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        Text("Apple Keynote")
            .bold()
            .transition(.move(edge: .bottom))

        Text("It's time to glow.")
            .font(.largeTitle)
            .bold()
            .overlay {
                LinearGradient(colors: [.purple, .yellow],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .blendMode(.lighten)
            }
            .transition(.move(edge: .bottom))
    }
    .frame(maxWidth: .infinity, minHeight: 180, alignment: .leading)
    .padding()
    .backgroundStyle(.regularMaterial)
    .mask {
        RoundedRectangle(cornerRadius: 16)
    }
    .safeAreaInset(edge: .leading, spacing: 0) {
        EmptyView()
            .frame(width: 16)
    }
    .safeAreaInset(edge: .trailing, spacing: 0) {
        EmptyView()
            .frame(width: 16)
    }
}
