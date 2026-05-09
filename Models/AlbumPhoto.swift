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

    /// JSONPlaceholder still points at `via.placeholder.com`, which often fails on iOS (blocked, empty body, or TLS quirks).
    /// Picsum URLs are deterministic per `id` and load reliably in `AsyncImage` and `URLSession`.
    var reliableImageURL: URL {
        URL(string: "https://picsum.photos/seed/minestagram-\(id)/900/900")!
    }

    var reliableThumbnailURL: URL {
        URL(string: "https://picsum.photos/seed/minestagram-thumb-\(id)/300/300")!
    }
}
