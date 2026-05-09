//
//  MinestagramApp.swift
//  Minestagram
//

import SwiftUI
import FirebaseCore

@main
struct MinestagramApp: App {
    private let persistenceController = PersistenceController.shared
    @StateObject private var remoteConfigViewModel = RemoteConfigViewModel()
    @AppStorage(MinestagramTheme.darkModeStorageKey) private var useDarkMode = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(remoteConfigViewModel)
                .preferredColorScheme(useDarkMode ? .dark : .light)
        }
    }
}
