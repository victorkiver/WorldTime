//
//  ClockView.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct ClockView: View {

    @AppStorage("appTheme") private var appTheme: AppTheme = .light

    @State private var viewModel = ClockViewModel(model: WorldTimeModel.sample[4])

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    print("settings action")
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

            HStack {
                Text("London,\nUnited Kingdom")
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
                Text("Daylight 12h 38m  •")
                    .foregroundStyle(Color.basic01)
                    .font(.meduim16)
                Text("06:12 - 18:20")
                    .foregroundStyle(Color.basic03)
                    .font(.meduim16)
                Spacer()
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background))
    }
}

@Observable
final class ClockViewModel {

    private(set) var hours: String = "00"
    private(set) var minutes: String = "00"
    private(set) var seconds: String = "00"
    private(set) var timeFormat: TimeFormat

    private let model: WorldTimeModel
    private let defaultsManager = DefaultsManager()

    init(model: WorldTimeModel) {
        self.model = model
        self.timeFormat = defaultsManager.timeFormat
        Self.dateFormatter.timeZone = TimeZone(secondsFromGMT: model.utcOffset * 60 * 60)
    }

    func update(timeFormat: TimeFormat) {
        defaultsManager.timeFormat = timeFormat
        self._timeFormat = timeFormat
    }

    func updateTime() {
        Self.dateFormatter.dateFormat = switch timeFormat {
        case .twelveHour: "hh:mm:ss"
        case .twentyFourHour: "HH:mm:ss"
        }
        let components = Self.dateFormatter.string(from: .now)
            .components(separatedBy: ":")
        hours = components[0]
        minutes = components[1]
        seconds = components[2]
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    fileprivate var time: String {
        Self.dateFormatter.timeZone = TimeZone(secondsFromGMT: model.utcOffset * 60 * 60)
        return Self.dateFormatter.string(from: Date())
    }
}

private struct DigitalClockView: View {

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

private struct TimeFormatToggle: View {

    @AppStorage("appTheme") private var appTheme: AppTheme = .light

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

#Preview {
    ClockView()
}
