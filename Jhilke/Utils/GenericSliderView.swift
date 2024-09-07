//
//  GenericSliderView.swift
//  Jhilke
//
//  Created by Prashanna Rajbhandari on 07/09/2024.
//

import SwiftUI

struct GenericSliderView<ValueType: BinaryFloatingPoint>: View {
    @Binding var value: ValueType
    var minValue: ValueType
    var maxValue: ValueType
    var label: String
    var imageStart: String
    var imageEnd: String
    var onValueChanged: (ValueType) -> Void

    var body: some View {
        HStack {
            Text(label)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 250, height: 30)
                    .foregroundColor(.gray.opacity(0.3))
                    .overlay {
                        ZStack {
                            GeometryReader { geometry in
                                HStack {
                                    let relativeValue = CGFloat(value - minValue) / CGFloat(maxValue - minValue)
                                    let calculatedWidth = relativeValue * geometry.size.width

                                    let newWidth = calculatedWidth <= 0 ? calculatedWidth + 10 : calculatedWidth

                                    RoundedRectangle(cornerRadius: 20)
                                        .frame(width: newWidth, height: 30)
                                        .foregroundColor(.white)
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { drag in

                                                    let dragX = max(0, min(drag.location.x, geometry.size.width))

                                                    let percentage = dragX / geometry.size.width
                                                    let newValue = ValueType(percentage) * (maxValue - minValue) + minValue

                                                    value = max(min(newValue, maxValue), minValue)

                                                    onValueChanged(value)
                                                }
                                        )
                                    Spacer()
                                }
                            }

                            HStack {
                                Image(systemName: imageStart)
                                Spacer()
                                Image(systemName: imageEnd)
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                        }
                    }
            }
        }
    }
}
