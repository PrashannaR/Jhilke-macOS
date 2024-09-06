//
//  MonitorBrightnessControl.swift
//  Jhilke
//
//  Created by Prashanna Rajbhandari on 04/09/2024.
//

/*
 TODO:
    add temperature control
    
 */

import CoreGraphics
import SwiftUI

struct MonitorBrightnessControl: View {
    @State private var selectedScreenIndex = 0
    let screens = NSScreen.screens
    @State private var brightness: Float = 100.0

    var body: some View {
        VStack(alignment: .leading) {
            Text("Control Screen Brightness")
                .font(.title2)

            Picker("Select Screen", selection: $selectedScreenIndex) {
                ForEach(0 ..< screens.count, id: \.self) { index in
                    Text("\(screens[index].localizedName)")
                }
            }
            .pickerStyle(.radioGroup)

            Slider(value: $brightness, in: 25 ... 100, step: 1) {
                Text("Brightness")
            }
            .frame(width: 300)
            .onChange(of: brightness) { _, newValue in
                setScreenBrightness(for: screens[selectedScreenIndex], brightness: newValue)
            }
        }
        .padding()
    }
}

#Preview {
    MonitorBrightnessControl()
}

extension MonitorBrightnessControl {
    //MARK: Set screen brightness
    private func setScreenBrightness(for screen: NSScreen, brightness: Float) {
        guard let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else {
            print("Failed to get display ID.")
            return
        }

        let gammaValue = brightness / 100.0
        setGamma(displayID: displayID, gamma: gammaValue)
    }
    //MARK: Set Gamma
    private func setGamma(displayID: CGDirectDisplayID, gamma: Float) {
        var redTable = [CGGammaValue](repeating: 0, count: 256)
        var greenTable = [CGGammaValue](repeating: 0, count: 256)
        var blueTable = [CGGammaValue](repeating: 0, count: 256)

        for i in 0 ..< 256 {
            let value = Float(i) / 255.0
            redTable[i] = CGGammaValue(value * gamma)
            greenTable[i] = CGGammaValue(value * gamma)
            blueTable[i] = CGGammaValue(value * gamma)
        }

        let result = CGSetDisplayTransferByTable(displayID, 256, redTable, greenTable, blueTable)
        if result != CGError.success {
            print("Error setting gamma: \(result)")
        }
    }
}
