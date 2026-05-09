//
//  GHContentRepository.swift
//  Minestagram
//

import Foundation

protocol GHContentRepositoryProtocol: Sendable {
    func fetchRootContents(owner: String, repo: String) async throws -> [GHContent]
}

/// Optional GitHub API helper (used if you want to wire real repo listings).
struct GHContentRepository: GHContentRepositoryProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchRootContents(owner: String, repo: String) async throws -> [GHContent] {
        let url = URL(string: "https://api.github.com/repos/\(owner)/\(repo)/contents")!
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([GHContent].self, from: data)
    }
}
