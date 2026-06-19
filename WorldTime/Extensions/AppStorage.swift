//
//  AppStorage.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

enum AppStorageKey: String {
    case appTheme
    case timeFormat
}

extension AppStorage {

    init(wrappedValue: Value, _ key: AppStorageKey, store: UserDefaults? = nil) where Value == AppTheme {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }

    init(wrappedValue: Value, _ key: AppStorageKey, store: UserDefaults? = nil) where Value == TimeFormat {
        self.init(wrappedValue: wrappedValue, key.rawValue, store: store)
    }
}
