//
//  AppSettings.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import Foundation
import SwiftUI

enum TimeFormat: String, CaseIterable {
    case twelveHour
    case twentyFourHour
}

enum AppTheme: String, CaseIterable {
    case light
    case dark
}

extension AppTheme: Identifiable {

    var id: Self { self }

    var colorScheme: ColorScheme {
        switch self {
        case .light: .light
        case .dark: .dark
        }
    }
}

protocol DefaultsManagerProtocol {
    var userDefault: UserDefaults { get }
    var timeFormat: TimeFormat { get set }
    var appTheme: AppTheme { get set }

    func setValue<T>(_ value: T?, for key: UserDefaultsKey)
    func value<T>(forKey: UserDefaultsKey) -> T?
}

extension DefaultsManagerProtocol {

    func setValue<T>(_ value: T?, for key: UserDefaultsKey) {
        userDefault.setValue(value, forKey: key.rawValue)
    }

    func value<T>(forKey key: UserDefaultsKey) -> T? {
        return userDefault.value(forKey: key.rawValue) as? T
    }
}

@MainActor
final class DefaultsManager: DefaultsManagerProtocol, @unchecked Sendable {

    let userDefault: UserDefaults = UserDefaults.standard

    nonisolated init() {}

    var timeFormat: TimeFormat {
        get { TimeFormat(rawValue: value(forKey: .timeFormat) ?? "") ?? .twentyFourHour }
        set { setValue(newValue.rawValue, for: .timeFormat) }
    }

    var appTheme: AppTheme {
        get { AppTheme(rawValue: value(forKey: .appTheme) ?? "") ?? .light }
        set { setValue(newValue.rawValue, for: .appTheme) }
    }
}

enum UserDefaultsKey: String {
    case timeFormat
    case appTheme
}
