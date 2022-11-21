//
//  PieChart.swift
//  IleZarabiam
//
//  Created by Tomasz Ogrodowski on 20/11/2022.
//

import SwiftUI

struct PieChartSliceData {
    var value: Double
    var associatedColor: Color
    
    init(_ value: Double, _ associatedColor: Color) {
        self.value = value
        self.associatedColor = associatedColor
    }
}

struct PieChart: View {
    @State var slices: [PieChartSliceData]

        var body: some View {
            Canvas { context, size in
                let total = slices.reduce(0) { $0 + $1.value }
                context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
                var pieContext = context
                pieContext.rotate(by: .degrees(-90))
                let radius = min(size.width, size.height) * 0.48
                var startAngle = Angle.zero
                for slice in slices {
                    let angle = Angle(degrees: 360 * (slice.value / total))
                    let endAngle = startAngle + angle
                    let path = Path { p in
                        p.move(to: .zero)
                        p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                        p.closeSubpath()
                    }
                    pieContext.fill(path, with: .color(slice.associatedColor))

                    startAngle = endAngle
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(slices: [
            PieChartSliceData(12, .red),
            PieChartSliceData(3.5, .orange),
            PieChartSliceData(4, .yellow),
            PieChartSliceData(1, .green),
            PieChartSliceData(5, .blue),
            PieChartSliceData(4, .indigo),
            PieChartSliceData(2, .purple)
        ])
    }
}
