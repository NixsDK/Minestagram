//
//  MainTabView.swift
//  Minestagram
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var tabController = TabController()
    @EnvironmentObject private var remoteConfigViewModel: RemoteConfigViewModel

    var body: some View {
        TabView(selection: $tabController.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
            }
            .tag(AppTab.home)

            NavigationStack {
                PhotosTabView()
            }
            .tabItem {
                Label(AppTab.photos.title, systemImage: AppTab.photos.systemImage)
            }
            .tag(AppTab.photos)

            NavigationStack {
                VideosTabView()
            }
            .tabItem {
                Label(AppTab.videos.title, systemImage: AppTab.videos.systemImage)
            }
            .tag(AppTab.videos)

            NavigationStack {
                PhotosMapView()
            }
            .tabItem {
                Label(AppTab.map.title, systemImage: AppTab.map.systemImage)
            }
            .tag(AppTab.map)
        }
        .tint(.primary)
        .task {
            await remoteConfigViewModel.refreshWhatsNewFlag()
        }
        .sheet(isPresented: $remoteConfigViewModel.presentWhatsNew) {
            WhatsNewView {
                remoteConfigViewModel.dismissWhatsNew()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(RemoteConfigViewModel(service: MockRemoteConfigService()))
}
