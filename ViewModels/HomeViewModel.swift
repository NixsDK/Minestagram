//
//  HomeViewModel.swift
//  Minestagram
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var photos: [AlbumPhoto] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let userRepository: UserRepositoryProtocol
    private let albumRepository: AlbumPhotoRepositoryProtocol

    init(
        userRepository: UserRepositoryProtocol = UserRepository(),
        albumRepository: AlbumPhotoRepositoryProtocol = AlbumPhotoRepository()
    ) {
        self.userRepository = userRepository
        self.albumRepository = albumRepository
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let userTask = userRepository.fetchUser(id: 1)
            async let photosTask = albumRepository.fetchAlbumPhotos(albumId: 1)
            let (fetchedUser, fetchedPhotos) = try await (userTask, photosTask)
            user = fetchedUser
            photos = Array(fetchedPhotos.prefix(30))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
