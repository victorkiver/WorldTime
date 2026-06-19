//
//  TimeFormat.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import Foundation

enum TimeFormat: String, CaseIterable {
    case twelveHour
    case twentyFourHour
}

extension TimeFormat {
    static let `default`: TimeFormat = .twentyFourHour
}
