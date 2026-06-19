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
    let country: String
    let city: String
    let daylight1: String
    let daylight2: String
    let isHighlighted: Bool
}

extension WorldTimeModel {

    private static let timeFormatter: DateFormatter = .make()

    enum TimeStyle {
        case short
        case long
    }

    func formatted(_ format: TimeFormat, timeStyle: TimeStyle) -> (time: String, date: String, period: TimePeriod) {
        Self.timeFormatter.timeZone = TimeZone(secondsFromGMT: utcOffset * 60 * 60)

        Self.timeFormatter.dateFormat = switch format {
        case .twelveHour:
            switch timeStyle {
            case .short: "hh:mm"
            case .long: "hh:mm:ss"
            }
        case .twentyFourHour:
            switch timeStyle {
            case .short: "HH:mm"
            case .long: "HH:mm:ss"
            }
        }
        let time = Self.timeFormatter.string(from: .now)

        Self.timeFormatter.dateFormat = "EEE, d MMM"
        let date = Self.timeFormatter.string(from: .now)

        let period: TimePeriod = if let hours = time.components(separatedBy: ":").first?.intValue {
            6..<18 ~= hours ? .day : .night
        } else {
            .day
        }

        return (time, date, period)
    }

    func utc() -> String {
        "UTC\(utcOffset >= 0 ? "+" : "-")\(abs(utcOffset))"
    }
}

extension WorldTimeModel {

    static let sample: [WorldTimeModel] = [
        WorldTimeModel(
            identifier: "1",
            utcOffset: +9,
            country: "Japan",
            city: "Tokyo",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "2",
            utcOffset: +11,
            country: "Australia",
            city: "Sydney",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "3",
            utcOffset: -8,
            country: "USA",
            city: "Los Angeles",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "4",
            utcOffset: -5,
            country: "USA",
            city: "New York",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "5",
            utcOffset: +0,
            country: "United Kingdom",
            city: "London",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: true
        ),
        WorldTimeModel(
            identifier: "6",
            utcOffset: +1,
            country: "Algiers",
            city: "Algiers",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "7",
            utcOffset: -9,
            country: "Canada",
            city: "Alaska",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "8",
            utcOffset: +2,
            country: "Lebanon",
            city: "Beirut",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        ),
        WorldTimeModel(
            identifier: "9",
            utcOffset: +10,
            country: "Australia",
            city: "Brisbane",
            daylight1: "Daylight 12h 38m  •",
            daylight2: "06:12 - 18:20",
            isHighlighted: false
        )
    ]
}
