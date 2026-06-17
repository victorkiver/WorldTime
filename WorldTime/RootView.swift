//
//  RootView.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct RootView: View {

    @State private var selectedTab: Tab = .dashboard

    var body: some View {
        ZStack(alignment: .bottom) {
            TabContentView(selectedTab: selectedTab)

            HStack(spacing: 24) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabButton(tab: tab, isActive: selectedTab == tab) {
                        selectedTab = tab
                    }
                }
            }
            .padding(.bottom, 16)
        }
    }
}

private enum Tab: Int, CaseIterable {
    case dashboard
    case clock
    case map
}

extension Tab {

    var icon: Image {
        switch self {
        case .dashboard: Image(.icSearch)
        case .clock: Image(.icClock)
        case .map: Image(.icWorld)
        }
    }
}

private struct TabButton: View {

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
            tab.icon
                .resizable()
                .font(.system(size: 18, weight: .semibold))
                .symbolEffect(.bounce, value: bounceValue)
                .foregroundStyle(isActive ? .white : .black)
                .frame(width: 22, height: 22)
                .padding(14)
                .background(
                    Circle()
                        .fill(isActive ? Color.black : Color.gray.opacity(0.2))
                )
                .scaleEffect(isActive ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

private struct TabContentView: View {

    var selectedTab: Tab

    var body: some View {
        Group {
            switch selectedTab {
            case .dashboard:
                DashboardView()
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
