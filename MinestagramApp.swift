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

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(remoteConfigViewModel)
        }
    }
}
