//
//  TimeFormatToggle.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct TimeFormatToggle: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    @State var format: TimeFormat

    @Namespace private var toggleNamespace

    private let action: (TimeFormat) -> Void

    init(format: TimeFormat, action: @escaping (TimeFormat) -> Void) {
        self.format = format
        self.action = action
    }

    var body: some View {
        HStack(spacing: -6) {
            toggleLabel(.twelveHour, isSelected: format == .twelveHour)
            toggleLabel(.twentyFourHour, isSelected: format == .twentyFourHour)
        }
        .padding(2)
        .background(
            Capsule()
                .fill(Color.bgBox)
        )
    }

    private func toggleLabel(_ format: TimeFormat, isSelected: Bool) -> some View {
        Text(format == .twelveHour ? "12h" : "24h")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(isSelected ? Color.basic01 : Color.basic03)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background {
                if isSelected {
                    Capsule()
                        .fill(Color(.basic01.inverted(by: appTheme)))
                        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                        .matchedGeometryEffect(id: "pill", in: toggleNamespace)
                }
            }
            .contentShape(Capsule())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    self.format = format
                    self.action(format)
                }
            }
    }
}
