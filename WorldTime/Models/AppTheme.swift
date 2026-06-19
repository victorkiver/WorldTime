//
//  AppTheme.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

enum AppTheme: String, CaseIterable {
    case light
    case dark
}

extension AppTheme: Identifiable {

    static let `default`: Self = .light

    var id: Self { self }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }

    var label: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var isDark: Bool {
        switch self {
        case .light: false
        case .dark: true
        }
    }
}
