//
//  ClockView.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct ClockView: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    @State private var viewModel = ClockViewModel(model: WorldTimeModel.sample[4])

    @State private var showThemePicker = false

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    showThemePicker = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.bgBox)
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 8, x: 0, y: 4
                            )
                        Image(.icTheme)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.basic01.inverted(by: appTheme))
                    }
                }
                .frame(width: 36, height: 36)

                Spacer()

                TimeFormatToggle(
                    format: viewModel.timeFormat,
                    action: {
                        viewModel.update(timeFormat: $0)
                    })
            }
            .padding(.horizontal, 16)

            HStack {
                DigitalClockView(viewModel: viewModel)
                Spacer()
            }
            .padding(.horizontal, 16)

            HStack(spacing: 20) {
                Text(viewModel.date)
                    .font(.medium28)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 16)

            HStack(spacing: 20) {
                Text(viewModel.location)
                    .font(.black36)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.horizontal, 16)

            HStack(spacing: 8) {
                Image(.icDayLight)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.basic01)
                Text(viewModel.daylight1)
                    .foregroundStyle(Color.basic01)
                    .font(.meduim16)
                Text(viewModel.daylight2)
                    .foregroundStyle(Color.basic03)
                    .font(.meduim16)
                Spacer()
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background))
        .sheet(isPresented: $showThemePicker) {
            ThemePickerSheet(appTheme: $appTheme)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(340)])
                .preferredColorScheme(appTheme.colorScheme)
        }
    }
}

#Preview {
    ClockView()
}
