//
//  WorldTimeModel.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import Foundation

struct WorldTimeModel: Sendable {
    let identifier: String
    let utcOffset: Int
    let city: String
    var isHighlighted: Bool
}

extension WorldTimeModel {

    static let sample: [WorldTimeModel] = [
        WorldTimeModel(identifier: "1", utcOffset: +9, city: "Tokyo", isHighlighted: false),
        WorldTimeModel(identifier: "2", utcOffset: +11, city: "Sydney", isHighlighted: false),
        WorldTimeModel(identifier: "3", utcOffset: -8, city: "Los Angeles", isHighlighted: true),
        WorldTimeModel(identifier: "4", utcOffset: -5, city: "New York", isHighlighted: false),
        WorldTimeModel(identifier: "5", utcOffset: +0, city: "London", isHighlighted: false),
        WorldTimeModel(identifier: "6", utcOffset: +1, city: "Algiers", isHighlighted: false)
    ]
}
