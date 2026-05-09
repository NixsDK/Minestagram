//
//  ThemeController.swift
//  Minestagram
//

import SwiftUI

@MainActor
final class ThemeController: ObservableObject {
    private static let storageKey = "MinestagramUseDarkMode"

    @Published var useDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(useDarkMode, forKey: Self.storageKey)
        }
    }

    init() {
        useDarkMode = UserDefaults.standard.bool(forKey: Self.storageKey)
    }

    func toggle() {
        useDarkMode.toggle()
    }
}
