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

    /// JSONPlaceholder image URLs often fail on iOS. These Unsplash IDs are rotated for a military / tactical / aviation theme (profile grid + Photos tab).
    private static let militaryUnsplashPhotoIDs = [
        "1520106212299-d99c443e4568", // carrier deck / jets
        "1544196958-34229ee680c0", // training / drill
        "1519006112096-9051bfafc377", // helicopter
        "1628177897482-3a0c0f04e709", // tactical / vehicle
        "1588669636305-95af05eb51a1", // jet cockpit / aviation
        "1509042239860-f550ce710b93", // field / ops mood
        "1518709268805-72e911f0b6f4", // arid / deployment landscape
        "1631627867058-0b8a05f97b8d" // uniform / personnel
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
