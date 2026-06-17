//
//  WorldTimeApp.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

@main
struct WorldTimeApp: App {

    @AppStorage("appTheme") private var theme: AppTheme = .light

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(theme.colorScheme)
        }
    }
}
