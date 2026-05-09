//
//  VideosViewModel.swift
//  Minestagram
//

import Foundation

@MainActor
final class VideosViewModel: ObservableObject {
    @Published private(set) var items: [VideoItem] = []

    func load() {
        items = [
            VideoItem(
                title: "Big Buck Bunny (clip)",
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
            ),
            VideoItem(
                title: "Elephant Dream",
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
            ),
            VideoItem(
                title: "For Bigger Blazes",
                streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!
            )
        ]
    }
}
