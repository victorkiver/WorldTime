//
//  ThemePickerSheet.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct ThemePickerSheet: View {

    @Binding var appTheme: AppTheme

    @Namespace private var themeNamespace

    var body: some View {
        VStack(spacing: 32) {
            ThemeLogoView(appTheme: appTheme)
                .padding(.top, 24)

            Text("Choose a theme")
                .font(.system(size: 22, weight: .bold))

            segments
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.bgBox.inverted(by: appTheme)
        )
    }

    private var segments: some View {
        HStack(spacing: 10) {
            ForEach(AppTheme.allCases) { theme in
                let isSelected = appTheme == theme
                Text(theme.label)
                    .font(isSelected ? .bold16 : .meduim16)
                    .foregroundStyle(isSelected ? .basic01.inverted(by: appTheme) : .basic02)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background {
                        if isSelected {
                            Capsule()
                                .fill(Color.basic01)
                                .matchedGeometryEffect(id: "themePill", in: themeNamespace)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
//                        let manager = DefaultsManager()
//                        manager.appTheme = theme
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                            appTheme = theme
                        }
                    }
            }
        }
        .padding(.horizontal, 10)
        .background(
            Capsule()
                .fill(Color.basic03)
                .opacity(0.05)
        )
    }
}
