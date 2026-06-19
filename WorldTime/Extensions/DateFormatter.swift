//
//  DateFormatter.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import Foundation

extension DateFormatter {

    static func make() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
