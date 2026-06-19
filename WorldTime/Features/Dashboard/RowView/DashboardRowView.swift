//
//  DashboardRowView.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct DashboardRowView: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    @State var viewModel: DashboardRowViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.utc)
                    .font(.meduim12)
                    .foregroundStyle(viewModel.isHighlighted ? Color.basic02.inverted(by: appTheme) : Color.basic02)
                Text(viewModel.city)
                    .font(.meduim16)
                    .foregroundStyle(viewModel.isHighlighted ? Color.basic01.inverted(by: appTheme) : Color.basic01)
            }

            Spacer()

            Text(viewModel.time)
                .font(viewModel.isHighlighted ? .bold28 : .medium24)
                .monospacedDigit()
                .foregroundStyle(viewModel.isHighlighted ? Color.basic01.inverted(by: appTheme) : Color.basic01)

            Image(viewModel.period.icon)
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.leading, 4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.isHighlighted ? Color.bgBox : Color.bgBox.inverted(by: appTheme))
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 4,
            x: 0, y: 4
        )
    }
}
