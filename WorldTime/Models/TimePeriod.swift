//
//  TimePeriod.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

enum TimePeriod {
    case day
    case night
}

extension TimePeriod {

    var icon: ImageResource {
        switch self {
        case .day: .icSun
        case .night: .icMoon
        }
    }
}
