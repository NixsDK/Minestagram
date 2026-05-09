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
    /// These Unsplash photos are military / aviation themed and load reliably over HTTPS.
    private static let militaryUnsplashPhotoIDs = [
        "1520106212299-d99c443e4568",
        "1504384308090-c894fdcc538d",
        "1588669636305-95af05eb51a1",
        "1545558014-8692077e9b5c",
        "1579910395959-15d91a1dc806",
        "1440098334710-ce400b492f4f"
    ]

    private static func unsplashSquareURL(photoID: String, size: Int) -> URL {
        URL(string: "https://images.unsplash.com/photo-\(photoID)?w=\(size)&h=\(size)&fit=crop&q=85")!
    }

    var reliableImageURL: URL {
        let photoID = Self.militaryUnsplashPhotoIDs[abs(id) % Self.militaryUnsplashPhotoIDs.count]
        return Self.unsplashSquareURL(photoID: photoID, size: 900)
    }

    var reliableThumbnailURL: URL {
        let photoID = Self.militaryUnsplashPhotoIDs[abs(id) % Self.militaryUnsplashPhotoIDs.count]
        return Self.unsplashSquareURL(photoID: photoID, size: 320)
    }
}
