//
//  ThemeLogoView.swift
//  WorldTime
//
//  Created by Victor Kiver on 18.06.2026.
//

import SwiftUI

struct ThemeLogoView: View {

    var appTheme: AppTheme

    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var themeNamespace

    var body: some View {
        if appTheme.isDark {
            MoonView(appTheme: appTheme)
        } else {
            SunView()
        }
    }
}

private struct SunView: View {

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.sun,
                        Color.sun,
                        Color.sun.opacity(0.85),
                        Color.sun.opacity(0.65),
                        Color.sun.opacity(0.35)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 150, height: 150)
    }
}

private struct MoonView: View {

    let appTheme: AppTheme

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.moon,
                            Color.moon,
                            Color.moon.opacity(0.85),
                            Color.moon.opacity(0.65),
                            Color.moon.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 150, height: 150)

            Circle()
                .foregroundStyle(Color.bgBox.inverted(by: appTheme))
                .frame(width: 135, height: 135)
                .offset(x: 25, y: -25)
                
        }
    }
}

#Preview {
    ThemeLogoView(appTheme: .light)
}
