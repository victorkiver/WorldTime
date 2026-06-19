//
//  DashboardViewModel.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

@Observable @MainActor final class DashboardViewModel {

    private(set) var rows: [DashboardRowViewModel] = WorldTimeModel
        .sample.map { DashboardRowViewModel($0) }

    func plusAction() {
        print("plus action")
    }

    func didSelectAction(row: DashboardRowViewModel) {
        print("select action: \(row.id)")
    }
}
