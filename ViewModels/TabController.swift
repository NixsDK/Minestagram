//
//  TabController.swift
//  Minestagram
//

import SwiftUI

enum AppTab: Int, CaseIterable, Identifiable {
    case home
    case photos
    case videos
    case map

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .home: "Home"
        case .photos: "Photos"
        case .videos: "Videos"
        case .map: "Map"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "person.fill"
        case .photos: "photo"
        case .videos: "video.fill"
        case .map: "map.fill"
        }
    }
}

final class TabController: ObservableObject {
    @Published var selectedTab: AppTab = .home
}
