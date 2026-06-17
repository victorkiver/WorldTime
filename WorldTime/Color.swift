//
//  Color.swift
//  WorldTime
//
//  Created by Victor Kiver on 17.06.2026.
//

import SwiftUI

extension Color {

    func inverted(by colorScheme: ColorScheme) -> Color {
        let traits = UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .light : .dark)
        let resolvedUIColor = UIColor(self).resolvedColor(with: traits)
        return Color(resolvedUIColor)
    }

    func inverted(by appTheme: AppTheme) -> Color {
        inverted(by: appTheme.colorScheme)
    }
}
