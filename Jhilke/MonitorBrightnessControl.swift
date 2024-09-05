//
//  MonitorBrightnessControl.swift
//  Jhilke
//
//  Created by Prashanna Rajbhandari on 04/09/2024.
//


import SwiftUI

struct MonitorBrightnessControl: View {
    @State private var selectedScreenIndex = 0
    let screens = NSScreen.screens
    @State private var brightness: Float = 50.0

    var body: some View {
        VStack(alignment: .leading) {
            Text("Control Screen Brightness")
                .font(.title2)

            Picker("Select Screen", selection: $selectedScreenIndex) {
                ForEach(0 ..< screens.count, id: \.self) { index in
                    Text("Screen \(index + 1): \(screens[index].localizedName)")
                }
            }
            .pickerStyle(.radioGroup)

            Slider(value: $brightness, in: 0 ... 100, step: 1) {
                Text("Brightness")
            }
            .frame(width: 300)
            
        }
        .padding()
    }
}

#Preview {
    MonitorBrightnessControl()
}

