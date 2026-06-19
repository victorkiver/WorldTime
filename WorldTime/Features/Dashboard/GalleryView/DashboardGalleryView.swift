//
//  DashboardGalleryView.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct DashboardGalleryView: View {

    @State private var visibleItems: Set<Int> = []

    let images: [ImageResource]

    var body: some View {
        HStack(spacing: -12) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                RowView(image: image)
                    .opacity(visibleItems.contains(index) ? 1 : 0)
                    .offset(x: visibleItems.contains(index) ? 0 : -30)
            }
        }
        .onAppear {
            animateAppear()
        }
    }

    private func animateAppear() {
        for index in images.indices {
            _ = withAnimation(
                .spring(response: 0.45, dampingFraction: 0.7)
                .delay(Double(index) * 0.06)) {
                visibleItems.insert(index)
            }
        }
    }
}

private struct RowView: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    let image: ImageResource

    var body: some View {
        ZStack {
            Color.bgBox.inverted(by: appTheme)

            Image(image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(1.5)
        }
        .frame(width: 38, height: 32)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
