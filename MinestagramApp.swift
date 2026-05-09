//
//  MinestagramApp.swift
//  Minestagram
//

import SwiftUI
import FirebaseCore

@main
struct MinestagramApp: App {
    @StateObject private var remoteConfigViewModel = RemoteConfigViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(remoteConfigViewModel)
        }
    }
}
