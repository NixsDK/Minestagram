//
//  MinestagramTheme.swift
//  Minestagram
//

import SwiftUI

/// “Minestegram”-style brand chrome: bright yellow navigation header, gold accents.
enum MinestagramTheme {
    /// Header band (school-bus / Minion yellow, close to reference screenshots).
    static let brandYellow = Color(red: 1.0, green: 0.85, blue: 0.0)

    /// Darker gold for play accents, tab tint, map pins (readable on yellow + white).
    static let accentGold = Color(red: 0.72, green: 0.52, blue: 0.0)

    static let gridSpacing: CGFloat = 3
}

struct MinestagramNavigationChrome: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .toolbarBackground(MinestagramTheme.brandYellow, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(colorScheme == .dark ? .dark : .light, for: .navigationBar)
    }
}

extension View {
    func minestagramNavigationChrome() -> some View {
        modifier(MinestagramNavigationChrome())
    }
}

struct MinestagramThemeToolbar: ViewModifier {
    @EnvironmentObject private var themeController: ThemeController

    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    themeController.toggle()
                } label: {
                    Image(systemName: themeController.useDarkMode ? "sun.max.fill" : "moon.fill")
                        .symbolRenderingMode(.hierarchical)
                }
                .accessibilityLabel(themeController.useDarkMode ? "Use light appearance" : "Use dark appearance")
            }
        }
    }
}

extension View {
    func minestagramThemeToolbar() -> some View {
        modifier(MinestagramThemeToolbar())
    }
}
