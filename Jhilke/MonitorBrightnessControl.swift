//
//  MonitorBrightnessControl.swift
//  Jhilke
//
//  Created by Prashanna Rajbhandari on 04/09/2024.
//

import CoreGraphics
import SwiftUI

struct MonitorBrightnessControl: View {
    @State private var selectedScreenIndex = 0
    let screens = NSScreen.screens
    @State private var brightness: Float = 100.0

    let minBrightness: CGFloat = 25
    let maxBrightness: CGFloat = 100

    @State private var temperature: Float = 6500.0
    let minTemperature: Float = 2000
    let maxTemperature: Float = 10000

    var body: some View {
        VStack(alignment: .leading) {
            Text("Jhilke ;)")
                .font(.title2)

            Picker("Select Screen", selection: $selectedScreenIndex) {
                ForEach(0 ..< screens.count, id: \.self) { index in
                    Text("\(screens[index].localizedName)")
                }
            }
            .pickerStyle(.radioGroup)
            
            //brightness
            GenericSliderView(value: $brightness, minValue: Float(minBrightness), maxValue: Float(maxBrightness), label: "Brightness", imageStart: "sun.min", imageEnd: "sun.max") { newBrightness in
                setScreenBrightness(for: screens[selectedScreenIndex], brightness: newBrightness, temperature: temperature)
            }
            
            //temperature
            GenericSliderView(value: $temperature, minValue: minTemperature, maxValue: maxTemperature, label: "Temperature", imageStart: "thermometer.sun", imageEnd: "thermometer.snowflake") { newTemp in
                setScreenBrightness(for: screens[selectedScreenIndex], brightness: brightness, temperature: newTemp)
            }
        }
        .padding()
    }
}

#Preview {
    MonitorBrightnessControl()
}

extension MonitorBrightnessControl {
    // MARK: Set screen brightness

    private func setScreenBrightness(for screen: NSScreen, brightness: Float, temperature: Float) {
        guard let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else {
            print("Failed to get display ID.")
            return
        }

        let gammaValue = brightness / 100.0
        setGamma(displayID: displayID, gamma: gammaValue, temperature: temperature)
    }

    // MARK: Set Gamma and Temperature

    private func setGamma(displayID: CGDirectDisplayID, gamma: Float, temperature: Float) {
        var redTable = [CGGammaValue](repeating: 0, count: 256)
        var greenTable = [CGGammaValue](repeating: 0, count: 256)
        var blueTable = [CGGammaValue](repeating: 0, count: 256)

        for i in 0 ..< 256 {
            let value = Float(i) / 255.0
            let tempFactor = temperatureFactor(temperature: temperature)

            redTable[i] = CGGammaValue(value * gamma * tempFactor.red)
            greenTable[i] = CGGammaValue(value * gamma * tempFactor.green)
            blueTable[i] = CGGammaValue(value * gamma * tempFactor.blue)
        }

        let result = CGSetDisplayTransferByTable(displayID, 256, redTable, greenTable, blueTable)
        if result != CGError.success {
            print("Error setting gamma: \(result)")
        }
    }


    private func temperatureFactor(temperature: Float) -> (red: Float, green: Float, blue: Float) {
        let t = temperature / 100

        let red: Float = t <= 66 ? 1.0 : min(max(329.698727446 * pow(t - 60, -0.1332047592), 0), 255) / 255
        let green: Float = t <= 66 ? min(max(99.4708025861 * log(t) - 161.1195681661, 0), 255) / 255 : min(max(288.1221695283 * pow(t - 60, -0.0755148492), 0), 255) / 255
        let blue: Float = t >= 66 ? 1.0 : (t <= 19 ? 0 : min(max(138.5177312231 * log(t - 10) - 305.0447927307, 0), 255) / 255)

        return (red, green, blue)
    }
}
