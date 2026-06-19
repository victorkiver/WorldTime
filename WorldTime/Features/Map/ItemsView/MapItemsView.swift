//
//  MapItemsView.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct MapItemsView: View {

    let visible: Bool

    let viewModels: [MapItemViewModel] = [
        MapItemViewModel(WorldTimeModel.sample[4], image: .images0),
        MapItemViewModel(WorldTimeModel.sample[0], image: .images1),
        MapItemViewModel(WorldTimeModel.sample[1], image: .images2),
        MapItemViewModel(WorldTimeModel.sample[2], image: .images3),
        MapItemViewModel(WorldTimeModel.sample[3], image: .images4),
        MapItemViewModel(WorldTimeModel.sample[5], image: .images5)
    ]

    @State private var visibleItems: Set<Int> = []

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(Array(viewModels.enumerated()), id: \.element.id) { index, viewModel in
                    MapItemView(viewModel: viewModel)
                        .opacity(visibleItems.contains(index) ? 1 : 0)
                        .offset(x: visibleItems.contains(index) ? 0 : 40)
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.never)
        .onChange(of: visible) { _, isVisible in
            guard isVisible else { return }
            for index in viewModels.indices {
                _ = withAnimation(
                    .spring(response: 0.5, dampingFraction: 0.7)
                    .delay(Double(index) * 0.07)) {
                    visibleItems.insert(index)
                }
            }
        }
    }
}
