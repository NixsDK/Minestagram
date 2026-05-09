//
//  AlbumPhoto.swift
//  Minestagram
//
//  WHERE TO GET IMAGE URLS (paste into `militaryImageURLStrings` below)
//  --------------------------------------------------------------------
//  You need **direct** links: opening the URL in a browser should show *only* the image (or start a download).
//
//  • Unsplash — https://unsplash.com/s/photos/military
//    Open a photo → right‑click the big image → **Open Image in New Tab** → copy the address bar
//    (starts with `https://images.unsplash.com/photo-...`).
//
//  • Pexels — https://www.pexels.com/search/military/
//    Open a photo → **Free download** (or right‑click image → **Copy image address**).
//
//  • Pixabay — https://pixabay.com/images/search/military/
//    Similar: use the actual image file URL, not the gallery page.
//
//  Avoid Pinterest *idea* pages, Google Images search pages, etc. — those are HTML, not image files.
//  Add one `"...",` line per image; the app cycles by JSONPlaceholder photo `id`.
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
        "https://images.unsplash.com/photo-1520106212299-d99c443e4568?fm=jpg&w=900&h=900&fit=crop&q=80",
        "https://images.unsplash.com/photo-1544196958-34229ee680c0?fm=jpg&w=900&h=900&fit=crop&q=80",
        "https://images.unsplash.com/photo-1519006112096-9051bfafc377?fm=jpg&w=900&h=900&fit=crop&q=80",
        "https://images.unsplash.com/photo-1628177897482-3a0c0f04e709?fm=jpg&w=900&h=900&fit=crop&q=80",
        "https://images.unsplash.com/photo-1588669636305-95af05eb51a1?fm=jpg&w=900&h=900&fit=crop&q=80",
        "https://images.unsplash.com/photo-1509042239860-f550ce710b93?fm=jpg&w=900&h=900&fit=crop&q=80"
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
