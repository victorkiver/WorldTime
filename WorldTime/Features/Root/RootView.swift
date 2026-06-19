//
//  RootView.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct RootView: View {

    @State private var selectedTab: Tab = .dashboard
    @State private var showGallery = false
    @State private var galleryTapOrigin: CGPoint = .zero
    @State private var galleryImages: [ImageResource] = []

    var body: some View {
        ZStack(alignment: .bottom) {
            TabContentView(selectedTab: selectedTab) { images, origin in
                galleryImages = images
                galleryTapOrigin = origin
                showGallery = true
            }

            HStack(spacing: 24) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabButton(tab: tab, isActive: selectedTab == tab) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.bottom, 16)
        }
        .overlay {
            if showGallery {
                FullScreenGalleryView(
                    images: galleryImages,
                    tapOrigin: galleryTapOrigin,
                    onDismiss: { showGallery = false }
                )
            }
        }
    }
}

private enum Tab: Int, CaseIterable {
    case dashboard
    case clock
    case map
}

extension Tab {

    var icon: ImageResource {
        switch self {
        case .dashboard: .icSearch
        case .clock: .icClock
        case .map: .icWorld
        }
    }
}

private struct TabButton: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    @State private var bounceValue: Int = 0

    let tab: Tab
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button {
            bounceValue += 1
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                action()
            }
        } label: {
            Image(tab.icon)
                .resizable()
                .font(.system(size: 18, weight: .semibold))
                .symbolEffect(.bounce, value: bounceValue)
                .foregroundStyle(isActive ? Color.basic01.inverted(by: appTheme) : .basic01)
                .frame(width: 22, height: 22)
                .padding(14)
                .background(
                    Circle()
                        .fill(isActive ? .basic01 : Color.bgBox.inverted(by: appTheme))
                )
                .scaleEffect(isActive ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

private struct TabContentView: View {

    var selectedTab: Tab
    var onOpenGallery: ([ImageResource], CGPoint) -> Void

    var body: some View {
        Group {
            switch selectedTab {
            case .dashboard:
                DashboardView(onOpenGallery: onOpenGallery)
            case .clock:
                ClockView()
            case .map:
                MapView()
            }
        }
        .id(selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RootView()
}
