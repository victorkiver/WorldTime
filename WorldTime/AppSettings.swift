//
//  AppSettings.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import Foundation

enum TimeFormat: String, CaseIterable {
    case twelveHour
    case twentyFourHour
}

enum Theme: String, CaseIterable {
    case light
    case dark
}

protocol DefaultsManagerProtocol {
    var userDefault: UserDefaults { get }
    var timeFormat: TimeFormat { get set }

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
}

enum UserDefaultsKey: String {
    case timeFormat
}
