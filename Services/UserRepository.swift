//
//  UserRepository.swift
//  Minestagram
//

import Foundation

protocol UserRepositoryProtocol: Sendable {
    func fetchUser(id: Int) async throws -> User
}

struct UserRepository: UserRepositoryProtocol {
    private let session: URLSession
    private let baseURL: URL

    init(
        session: URLSession = .shared,
        baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
    ) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchUser(id: Int) async throws -> User {
        let url = baseURL.appendingPathComponent("users/\(id)")
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        var user = try JSONDecoder().decode(User.self, from: data)
        if user.avatarURL == nil {
            user.avatarURL = "https://i.pravatar.cc/300?u=\(user.id)"
        }
        return user
    }
}
