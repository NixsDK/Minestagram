//
//  PhotosViewModel.swift
//  Minestagram
//

import Foundation

@MainActor
final class PhotosViewModel: ObservableObject {
    @Published private(set) var posts: [PhotoPost] = []
    @Published private(set) var isLoadingMetadata = false
    @Published private(set) var isCachingImages = false
    @Published private(set) var cachingProgress: (current: Int, total: Int) = (0, 0)
    @Published var errorMessage: String?

    private let userRepository: UserRepositoryProtocol
    private let albumRepository: AlbumPhotoRepositoryProtocol
    private let imageCache: ImageCacheService

    init(
        userRepository: UserRepositoryProtocol = UserRepository(),
        albumRepository: AlbumPhotoRepositoryProtocol = AlbumPhotoRepository(),
        imageCache: ImageCacheService = .shared
    ) {
        self.userRepository = userRepository
        self.albumRepository = albumRepository
        self.imageCache = imageCache
    }

    /// Loads post list, restores local URLs from disk when offline, then caches images **one at a time** when online.
    func load() async {
        errorMessage = nil
        isLoadingMetadata = true
        defer { isLoadingMetadata = false }

        do {
            let user = try await userRepository.fetchUser(id: 1)
            let album = try await albumRepository.fetchAlbumPhotos(albumId: 1)
            let slice = Array(album.prefix(20))
            let avatar = user.avatarURL.flatMap { URL(string: $0) }

            var built: [PhotoPost] = slice.map { photo in
                PhotoPost(
                    id: photo.id,
                    username: user.name ?? "User \(user.id)",
                    avatarURL: avatar,
                    remoteImageURL: URL(string: photo.url)!,
                    localImageURL: nil
                )
            }

            // Offline-first: attach any existing cached files before network image pass.
            for index in built.indices {
                if let local = await imageCache.localFileURLIfCached(for: built[index].remoteImageURL) {
                    built[index].localImageURL = local
                }
            }
            posts = built

            await cacheImagesSequentially()
        } catch {
            errorMessage = error.localizedDescription
            await loadOfflineOnlyFromExistingCache()
        }
    }

    private func loadOfflineOnlyFromExistingCache() async {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let metaDir = documents.appendingPathComponent("MinestagramPostsMeta", isDirectory: true)
        let indexURL = metaDir.appendingPathComponent("posts.json")
        guard let data = try? Data(contentsOf: indexURL),
              let decoded = try? JSONDecoder().decode([PhotoPostDTO].self, from: data)
        else {
            return
        }
        var restored: [PhotoPost] = decoded.map { dto in
            var local: URL?
            if let path = dto.localRelativePath {
                local = documents.appendingPathComponent(path)
            }
            return PhotoPost(
                id: dto.id,
                username: dto.username,
                avatarURL: dto.avatarURLString.flatMap { URL(string: $0) },
                remoteImageURL: URL(string: dto.remoteImageURLString)!,
                localImageURL: local
            )
        }
        for i in restored.indices {
            if restored[i].localImageURL == nil {
                if let hit = await imageCache.localFileURLIfCached(for: restored[i].remoteImageURL) {
                    restored[i].localImageURL = hit
                }
            }
        }
        posts = restored
    }

    private func cacheImagesSequentially() async {
        guard !posts.isEmpty else { return }
        isCachingImages = true
        cachingProgress = (0, posts.count)
        defer {
            isCachingImages = false
            cachingProgress = (posts.count, posts.count)
        }

        for index in posts.indices {
            cachingProgress = (index, posts.count)
            do {
                let local = try await imageCache.cachedFileURL(for: posts[index].remoteImageURL)
                posts[index].localImageURL = local
            } catch {
                if posts[index].localImageURL == nil {
                    errorMessage = error.localizedDescription
                }
            }
        }
        await persistPostIndex()
    }

    private func persistPostIndex() async {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let metaDir = documents.appendingPathComponent("MinestagramPostsMeta", isDirectory: true)
        try? fileManager.createDirectory(at: metaDir, withIntermediateDirectories: true)
        let relative = "MinestagramImageCache"
        let dtos: [PhotoPostDTO] = posts.map { post in
            let rel: String?
            if let local = post.localImageURL,
               local.path.hasPrefix(documents.path)
            {
                let path = String(local.path.dropFirst(documents.path.count)).trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                rel = path
            } else {
                rel = nil
            }
            return PhotoPostDTO(
                id: post.id,
                username: post.username,
                avatarURLString: post.avatarURL?.absoluteString,
                remoteImageURLString: post.remoteImageURL.absoluteString,
                localRelativePath: rel
            )
        }
        let url = metaDir.appendingPathComponent("posts.json")
        if let data = try? JSONEncoder().encode(dtos) {
            try? data.write(to: url, options: .atomic)
        }
    }
}

private struct PhotoPostDTO: Codable {
    let id: Int
    let username: String
    let avatarURLString: String?
    let remoteImageURLString: String
    let localRelativePath: String?
}
