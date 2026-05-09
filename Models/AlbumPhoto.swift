//
//  AlbumPhoto.swift
//  Minestagram
//

import Foundation

/// JSONPlaceholder album photo (grid + list source).
struct AlbumPhoto: Codable, Identifiable, Hashable {
    let albumId: Int
    let id: Int
    let title: String?
    let url: String
    let thumbnailUrl: String

    enum CodingKeys: String, CodingKey {
        case albumId
        case id
        case title
        case url
        case thumbnailUrl = "thumbnailUrl"
    }
}
