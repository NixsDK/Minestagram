//
//  VideoItem.swift
//  Minestagram
//

import Foundation

struct VideoItem: Identifiable, Hashable {
    let id: UUID
    let title: String
    let streamURL: URL

    init(id: UUID = UUID(), title: String, streamURL: URL) {
        self.id = id
        self.title = title
        self.streamURL = streamURL
    }
}
