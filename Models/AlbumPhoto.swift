//
//  AlbumPhoto.swift
//  Minestagram
//

import Foundation

/// JSONPlaceholder album photo (grid + list source).
/// **UI uses** `reliableImageURL` / `reliableThumbnailURL` — not `url` / `thumbnailUrl`.
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

    /// Replace / extend these with your own direct image URLs (see file comment at top).
    private static let militaryImageURLStrings: [String] = [
        "https://images.unsplash.com/photo-1569242840510-9fe6f0112cee?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fG1pbGl0YXJ5JTIwY29kfGVufDB8fDB8fHww",
        "https://plus.unsplash.com/premium_photo-1661964069634-2f493e28a14c?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWlsaXRhcnl8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1583872341575-610c859c7a57?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fG1pbGl0YXJ5fGVufDB8fDB8fHww",
        "https://images.unsplash.com/photo-1689270063328-f05e85c3b968?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fG1pbGl0YXJ5Y29kJTIwZ2hvc3R8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1723131834395-9e26fa23fdb0?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fENvRCUyMEdob3N0fGVufDB8fDB8fHww",
        "https://images.unsplash.com/photo-1699629151862-acbadd8cd8ed?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fG1pbGl0YXJ5JTIwdGFuayUyMGRhcmt8ZW58MHx8MHx8fDA%3D",
        "https://images.unsplash.com/photo-1621364525332-f9c381f3bfe8?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FsbCUyMG9mJTIwZHV0eXxlbnwwfHwwfHx8MA%3D%3D",
        "https://images.unsplash.com/photo-1602901248692-06c8935adac0?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2FsbCUyMG9mJTIwZHV0eXxlbnwwfHwwfHx8MA%3D%3D"
        
        
    ]

    private static var militaryURLs: [URL] {
        militaryImageURLStrings.compactMap {
            let t = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            return t.isEmpty ? nil : URL(string: t)
        }
    }

    /// Fallback if every string above is invalid (keeps the app usable while you fix URLs).
    private static let fallbackPhotoURL = URL(string: "https://picsum.photos/900/900")!

    var reliableImageURL: URL {
        let list = Self.militaryURLs
        guard !list.isEmpty else { return Self.fallbackPhotoURL }
        return list[abs(id) % list.count]
    }

    var reliableThumbnailURL: URL {
        reliableImageURL
    }
}
