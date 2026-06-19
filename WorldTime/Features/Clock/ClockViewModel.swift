//
//  ClockViewModel.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

@Observable @MainActor final class ClockViewModel {

    private(set) var hours: String = "00"
    private(set) var minutes: String = "00"
    private(set) var seconds: String = "00"
    private(set) var location: String = ""
    private(set) var date: String = ""
    private(set) var daylight1: String = ""
    private(set) var daylight2: String = ""
    private(set) var timeFormat: TimeFormat

    private let model: WorldTimeModel
    private let defaultsManager = DefaultsManager()

    init(model: WorldTimeModel) {
        self.model = model

        timeFormat = defaultsManager.timeFormat
        location = "\(model.country),\n\(model.city)"
        daylight1 = model.daylight1
        daylight2 = model.daylight2
    }

    func update(timeFormat: TimeFormat) {
        defaultsManager.timeFormat = timeFormat
        self.timeFormat = timeFormat
    }

    func updateTime() {
        let formatted = model.formatted(timeFormat, timeStyle: .long)
        let timeComponents = formatted.time.components(separatedBy: ":")
        (hours, minutes, seconds) = (timeComponents[0], timeComponents[1], timeComponents[2])
        date = formatted.date
    }
}
