//
//  WorldTimeApp.swift
//  DashboardView
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct DashboardView: View {

    @AppStorage("appTheme") private var appTheme: AppTheme = .light

    @State private var viewModels: [RowViewModel] = WorldTimeModel
        .sample.map { RowViewModel($0) }

    @State private var visibleRows: Set<Int> = []
    @State private var shadowOpacity: CGFloat = 0

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                GalleryView()
                    .padding(.leading, 16)

                Spacer()

                Button {
                    print("plus action")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.bgBox.inverted(by: appTheme))
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 8, x: 0, y: 4
                            )
                        Image(.icPlus)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color.basic01)
                    }
                }
                .frame(width: 36, height: 36)
                .padding(.trailing, 16)
                .padding(.vertical, 8)
            }
            .background(Color(.background))
            .shadow(
                color: .black.opacity(0.04 * shadowOpacity),
                radius: 6, x: 0, y: 9)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("World Time")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 24)

                    VStack(spacing: 12) {
                        ForEach(Array(viewModels.enumerated()), id: \.element.id) { index, viewModel in
                            RowView(viewModel: viewModel)
                                .opacity(visibleRows.contains(index) ? 1 : 0)
                                .offset(y: visibleRows.contains(index) ? 0 : 40)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.never)
            .onScrollGeometryChange(for: CGFloat.self, of: { geometry in
                geometry.contentOffset.y + geometry.contentInsets.top
            }, action: { _, newValue in
                let limited = min(max(0, newValue), 44)
                shadowOpacity = limited / 44
            })
        }
        .background(Color(.background))
        .onAppear {
            for index in viewModels.indices {
                _ = withAnimation(
                    .spring(response: 0.5, dampingFraction: 0.65)
                    .delay(Double(index) * 0.08)
                ) {
                    visibleRows.insert(index)
                }
            }
        }
    }
}

private struct RowView: View {

    @AppStorage("appTheme") private var appTheme: AppTheme = .light

    @State var viewModel: RowViewModel

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

            viewModel.timeOfDay.icon
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

private enum TimeOfDay {
    case day
    case night
}

extension TimeOfDay {

    var icon: Image {
        switch self {
        case .day: Image(.icSun)
        case .night: Image(.icMoon)
        }
    }
}

@Observable @MainActor
private final class RowViewModel: Identifiable {

    var id: String { model.identifier }

    private let model: WorldTimeModel

    private(set) var utc: String
    private(set) var city: String
    private(set) var time: String
    private(set) var timeOfDay: TimeOfDay
    private(set) var isHighlighted: Bool

    @ObservationIgnored
    private var timer: Timer?

    init(_ model: WorldTimeModel) {
        self.model = model
        self.utc = "UTC\(model.utcOffset >= 0 ? "+" : "-")\(abs(model.utcOffset))"
        self.city = model.city
        self.time = model.time
        self.timeOfDay = model.timeOfDay
        self.isHighlighted = model.isHighlighted
        start()
    }

    private func start() {
        stop()
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                Task { @MainActor [self] in
                    self.time = self.model.time
                    self.timeOfDay = self.model.timeOfDay
                }
            })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }
}

extension WorldTimeModel {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    fileprivate var time: String {
        Self.dateFormatter.timeZone = TimeZone(secondsFromGMT: utcOffset * 60 * 60)
        return Self.dateFormatter.string(from: Date())
    }

    fileprivate var timeOfDay: TimeOfDay {
        guard let stringHour = time.components(separatedBy: ":").first,
              let intHour = Int(stringHour) else {
            return .day
        }
        return 6..<18 ~= intHour ? .day : .night
    }
}

private struct GalleryView: View {

    private let images: [ImageResource] = [
        .images0, .images1, .images2, .images3, .images4, .images5
    ]

    @State private var visibleItems: Set<Int> = []

    var body: some View {
        HStack(spacing: -12) {
            ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                GalleryRow(image: image)
                    .opacity(visibleItems.contains(index) ? 1 : 0)
                    .offset(x: visibleItems.contains(index) ? 0 : -30)
            }
        }
        .onAppear {
            for index in images.indices {
                _ = withAnimation(
                    .spring(response: 0.45, dampingFraction: 0.7)
                    .delay(Double(index) * 0.06)
                ) {
                    visibleItems.insert(index)
                }
            }
        }
    }
}

private struct GalleryRow: View {

    @Environment(\.colorScheme) private var colorScheme

    let image: ImageResource

    var body: some View {
        ZStack {
            Color.bgBox.inverted(by: colorScheme)

            Image(image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(1.5)
        }
        .frame(width: 38, height: 32)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    DashboardView()
}
