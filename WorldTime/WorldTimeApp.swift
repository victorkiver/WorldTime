//
//  WorldTimeApp.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

@main
struct WorldTimeApp: App {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(appTheme.colorScheme)
        }
    }
}
