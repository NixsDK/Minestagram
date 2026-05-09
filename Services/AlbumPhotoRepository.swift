//
//  AlbumPhotoRepository.swift
//  Minestagram
//

import Foundation

protocol AlbumPhotoRepositoryProtocol: Sendable {
    func fetchAlbumPhotos(albumId: Int) async throws -> [AlbumPhoto]
}

struct AlbumPhotoRepository: AlbumPhotoRepositoryProtocol {
    private let session: URLSession
    private let baseURL: URL

    init(
        session: URLSession = .shared,
        baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    ) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchAlbumPhotos(albumId: Int) async throws -> [AlbumPhoto] {
        var components = URLComponents(url: baseURL.appendingPathComponent("photos"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "albumId", value: "\(albumId)")]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([AlbumPhoto].self, from: data)
    }
}
