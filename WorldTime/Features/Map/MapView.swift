//
//  MapView.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

struct MapView: View {

    @State private var titleVisible = false

    @State private var mapVisible = false

    @State private var itemsVisible = false

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Text("World Time")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                    .opacity(titleVisible ? 1 : 0)
                    .offset(y: titleVisible ? 0 : 20)

                Spacer()
            }

            Spacer()

            Image(.imgMap)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 16)
                .opacity(mapVisible ? 1 : 0)
                .scaleEffect(mapVisible ? 1 : 0.9)

            VStack {
                MapItemsView(visible: itemsVisible)
                Spacer()
            }

            Spacer()
        }
        .background(Color(.background))
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                titleVisible = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.15)) {
                mapVisible = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3)) {
                itemsVisible = true
            }
        }
    }
}

#Preview {
    MapView()
}
