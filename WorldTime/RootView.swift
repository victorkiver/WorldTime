import SwiftUI

enum Tab: Int, CaseIterable {
    case search
    case clock
    case settings

    var icon: Image {
        switch self {
        case .search: Image(.icSearch)
        case .clock: Image(.icClock)
        case .settings: Image(.icWorld)
        }
    }
}

struct RootView: View {
    @State private var selectedTab: Tab = .clock

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

private struct TabButton: View {
    let tab: Tab
    let isActive: Bool
    let action: () -> Void

    @State private var bounceValue: Int = 0

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
            case .search:
                SearchTabView()
            case .clock:
                ContentView()
            case .settings:
                SettingsTabView()
            }
        }
        .transition(.asymmetric(
            insertion: .scale(scale: 0.94).combined(with: .opacity),
            removal: .scale(scale: 1.04).combined(with: .opacity)
        ))
        .id(selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SettingsTabView: View {
    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
    }
}

#Preview {
    RootView()
}
