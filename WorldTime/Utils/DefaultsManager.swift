//
//  DefaultsManager.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import Foundation

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
        get { AppTheme(rawValue: value(forKey: .appTheme) ?? "") ?? .default }
        set { setValue(newValue.rawValue, for: .appTheme) }
    }
}

enum UserDefaultsKey: String {
    case timeFormat
    case appTheme
}
