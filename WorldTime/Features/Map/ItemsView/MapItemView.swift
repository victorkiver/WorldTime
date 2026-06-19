//
//  MapItemView.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct MapItemView: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    @State var viewModel: MapItemViewModel

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(viewModel.image)
                    .resizable()
                    .frame(width: 36, height: 30)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
                Spacer()
            }
            .padding([.top, .leading], 12)
            .padding(.bottom, 8)

            HStack {
                Text(viewModel.utc)
                    .font(.meduim12)
                    .foregroundStyle(viewModel.isHighlighted ? .basic02.inverted(by: appTheme) : .basic02)
                Spacer()
            }
            .padding(.horizontal, 12)

            HStack {
                Text(viewModel.city)
                    .font(.bold12)
                    .foregroundStyle(viewModel.isHighlighted ? .basic01.inverted(by: appTheme) : .basic01)
                Spacer()
            }
            .padding(.horizontal, 12)

            HStack {
                Text(viewModel.time)
                    .font(.bold24)
                    .foregroundStyle(viewModel.isHighlighted ? .basic01.inverted(by: appTheme) : .basic01)
                Spacer()
            }
            .padding([.horizontal, .bottom], 12)
        }
        .frame(width: 135)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
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
