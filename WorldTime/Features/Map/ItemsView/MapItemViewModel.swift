//
//  MapItemViewModel.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

@Observable @MainActor final class MapItemViewModel: Identifiable {

    var id: String { model.identifier }

    let model: WorldTimeModel
    let image: ImageResource

    private(set) var utc: String
    private(set) var city: String
    private(set) var time: String
    private(set) var period: TimePeriod
    private(set) var isHighlighted: Bool

    @ObservationIgnored
    private var timer: Timer?

    private let defaultsManager = DefaultsManager()

    init(_ model: WorldTimeModel, image: ImageResource) {
        self.model = model
        self.image = image
        self.utc = model.utc()
        self.city = model.city
        (self.time, _, self.period) = model.formatted(defaultsManager.timeFormat, timeStyle: .short)
        self.isHighlighted = model.isHighlighted
        start()
    }

    private func start() {
        stop()
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                Task { @MainActor [self] in
                    (self.time, _, self.period) = self.model
                        .formatted(self.defaultsManager.timeFormat, timeStyle: .short)
                }
            })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}
