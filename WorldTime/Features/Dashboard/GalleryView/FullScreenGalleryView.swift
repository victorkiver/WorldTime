//
//  FullScreenGalleryView.swift
//  DashboardView
//
//  Created by Victor Kiver on 19.06.2026.
//

import SwiftUI

struct FullScreenGalleryView: View {

    @Environment(\.safeAreaInsets) private var safeAreaInsets

    let images: [ImageResource]
    let initialIndex: Int
    let tapOrigin: CGPoint
    let onDismiss: () -> Void

    @State private var currentIndex: Int
    @State private var revealProgress: CGFloat = 0

    init(images: [ImageResource], initialIndex: Int = 0, tapOrigin: CGPoint, onDismiss: @escaping () -> Void) {
        self.images = images
        self.initialIndex = initialIndex
        self.tapOrigin = tapOrigin
        self.onDismiss = onDismiss
        self._currentIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            GeometryReader { geo in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: Binding(
                    get: { Optional(currentIndex) },
                    set: { currentIndex = $0 ?? 0 }
                ))
                .scrollIndicators(.never)
            }
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            revealProgress = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            onDismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding(.trailing, 16)
                    .padding(.top, safeAreaInsets.top)
                }

                Spacer()

                SnakePageIndicator(count: images.count, current: currentIndex)
                    .padding(.bottom, safeAreaInsets.bottom + 16)
            }
        }
        .clipShape(CircleRevealShape(origin: tapOrigin, progress: revealProgress))
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                revealProgress = 1
            }
        }
    }
}

private struct SnakePageIndicator: View {

    let count: Int
    let current: Int

    private let dotSize: CGFloat = 8
    private let spacing: CGFloat = 6

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: spacing) {
                ForEach(0..<count, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.35))
                        .frame(width: dotSize, height: dotSize)
                }
            }

            Circle()
                .fill(Color.white)
                .frame(width: dotSize, height: dotSize)
                .offset(x: CGFloat(current) * (dotSize + spacing))
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: current)
        }
    }
}

private struct CircleRevealShape: Shape {

    var origin: CGPoint
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let maxDx = max(origin.x, rect.width - origin.x)
        let maxDy = max(origin.y, rect.height - origin.y)
        let maxRadius = sqrt(maxDx * maxDx + maxDy * maxDy)
        let radius = maxRadius * progress

        return Path(ellipseIn: CGRect(
            x: origin.x - radius,
            y: origin.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
    }
}

#Preview {
    FullScreenGalleryView(
        images: [.images0, .images1, .images2, .images3, .images4],
        initialIndex: 0,
        tapOrigin: .zero,
        onDismiss: { }
    )
}
