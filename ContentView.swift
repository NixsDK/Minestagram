//
//  ContentView.swift
//  Minestagram
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(RemoteConfigViewModel(service: MockRemoteConfigService()))
}
