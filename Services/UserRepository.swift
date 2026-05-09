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
        if user.id == 1 {
            user.name = "Simon Riley"
            user.company = nil
            user.avatarURL = "https://wallpapers.com/images/high/ghost-skull-soldier-avatar-pey1ocsnnnv3z7wm.webp"
            user.bundledAvatarAssetName = nil
            user.bio = """
            Ghost – "Two goldfish are in a tank…?"
            Soap – "Go on…"
            Ghost – "One turns to the other and says, 'You know how to drive this thing?' Little army humor."
            Soap – "Very little…"
            Ghost – "Another?"
            Soap – "Please no…"
            Ghost – "Suit yourself."
            """
        } else if user.avatarURL == nil {
            user.avatarURL = "https://i.pravatar.cc/300?u=\(user.id)"
        }
        return user
    }
}
