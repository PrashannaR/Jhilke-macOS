//
//  MonitorBrightnessControl.swift
//  Jhilke
//
//  Created by Prashanna Rajbhandari on 04/09/2024.
//

import SwiftUI
import DDC

struct MonitorBrightnessControl: View {
    @State private var selectedScreenIndex = 0
    let screens = NSScreen.screens
    @State private var ddc: DDC?
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(0..<screens.count, id: \.self){ screen in
                Text("\(screens[screen].localizedName)")
            }
        }
        .padding()
    }
}

#Preview {
    MonitorBrightnessControl()
}
