//
//  JhilkeApp.swift
//  Jhilke
//
//  Created by Prashanna Rajbhandari on 04/09/2024.
//

import SwiftUI

@main
struct JhilkeApp: App {
    var body: some Scene {
        MenuBarExtra {
            MonitorBrightnessControl()
        } label: {
            Label("Jhilke", systemImage: "slider.horizontal.below.sun.max")
        }
        .menuBarExtraStyle(.window)

    }
}
