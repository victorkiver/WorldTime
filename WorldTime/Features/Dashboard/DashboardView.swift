//
//  WorldTimeApp.swift
//  DashboardView
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct DashboardView: View {

    @AppStorage(.appTheme) private var appTheme: AppTheme = .default

    @State private var visibleRows: Set<Int> = []
    @State private var shadowOpacity: CGFloat = 0
    @State private var viewModel = DashboardViewModel()

    let onOpenGallery: ([ImageResource], CGPoint) -> Void

    private let galleryImages: [ImageResource] = [.images0, .images1, .images2, .images3, .images4]

    var body: some View {
        VStack {
            headerView

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("World Time")
                        .font(.system(size: 34, weight: .bold))
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 24)

                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.rows.enumerated()), id: \.element.id) { index, row in
                            DashboardRowView(viewModel: row)
                                .opacity(visibleRows.contains(index) ? 1 : 0)
                                .offset(y: visibleRows.contains(index) ? 0 : 40)
                                .onTapGesture {
                                    viewModel.didSelectAction(row: row)
                                }
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
            animateAppear()
        }
    }

    private var headerView: some View {
        HStack(alignment: .center) {
            DashboardGalleryView(images: galleryImages)
                .padding(.leading, 16)
                .onTapGesture(coordinateSpace: .global) { location in
                    onOpenGallery(galleryImages, location)
                }

            Spacer()

            plusButton
                .frame(width: 36, height: 36)
                .padding(.trailing, 16)
                .padding(.vertical, 8)
        }
        .background(Color(.background))
        .shadow(
            color: .black.opacity(0.04 * shadowOpacity),
            radius: 6, x: 0, y: 9)
    }

    private var plusButton: some View {
        Button {
            viewModel.plusAction()
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
    }

    private func animateAppear() {
        for index in viewModel.rows.indices {
            _ = withAnimation(
                .spring(response: 0.5, dampingFraction: 0.65)
                .delay(Double(index) * 0.08)) {
                visibleRows.insert(index)
            }
        }
    }
}

#Preview {
    DashboardView(onOpenGallery: { _, _ in })
}
