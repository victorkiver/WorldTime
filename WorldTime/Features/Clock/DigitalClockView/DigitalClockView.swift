//
//  DigitalClockView.swift
//  WorldTime
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct DigitalClockView: View {

    @State var viewModel: ClockViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            TimeUnit(value: viewModel.hours, font: .black66)
                .foregroundStyle(Color.basic01)

            Text(":")
                .font(.black66)
                .foregroundStyle(Color.basic01)

            TimeUnit(value: viewModel.minutes, font: .black66)
                .foregroundStyle(Color.basic01)

            TimeUnit(value: viewModel.seconds, font: .black40)
                .foregroundStyle(Color.basic03)
                .padding(.leading, 4)
        }
        .task(id: viewModel.timeFormat) {
            viewModel.updateTime()
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.2))
                viewModel.updateTime()
            }
        }
    }
}

private struct TimeUnit: View {

    let value: String
    let font: Font

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(value.enumerated()), id: \.offset) { _, char in
                Text(String(char))
                    .font(font)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .animation(
                        .spring(response: 0.35, dampingFraction: 0.6),
                        value: char
                    )
            }
        }
    }
}
