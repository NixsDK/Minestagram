//
//  ImageCacheService.swift
//  Minestagram
//

import CryptoKit
import Foundation

/// Persists remote images under the app Documents directory for offline use.
actor ImageCacheService {
    static let shared = ImageCacheService()

    private let fileManager = FileManager.default
    private let cacheFolderName = "MinestagramImageCache"

    private var cacheDirectoryURL: URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(cacheFolderName, isDirectory: true)
    }

    private init() {}

    private func ensureCacheDirectory() {
        if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
        }
    }

    private func fileURL(forRemoteURL remote: URL) -> URL {
        let key = Self.stableFilename(for: remote)
        return cacheDirectoryURL.appendingPathComponent(key, isDirectory: false)
    }

    private static func stableFilename(for remote: URL) -> String {
        let data = Data(remote.absoluteString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Local file URL if a cached file exists for this remote URL.
    func localFileURLIfCached(for remote: URL) -> URL? {
        ensureCacheDirectory()
        let url = fileURL(forRemoteURL: remote)
        return fileManager.fileExists(atPath: url.path) ? url : nil
    }

    /// Downloads and writes to disk when missing; returns local file URL.
    func cachedFileURL(for remote: URL) async throws -> URL {
        ensureCacheDirectory()
        let destination = fileURL(forRemoteURL: remote)
        if fileManager.fileExists(atPath: destination.path) {
            return destination
        }
        let (data, response) = try await URLSession.shared.data(from: remote)
        guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        try data.write(to: destination, options: .atomic)
        return destination
    }

    /// All image files currently in the cache (for EXIF / map scanning). Does not require `await`.
    nonisolated static func allCachedImageFileURLs() -> [URL] {
        let fileManager = FileManager.default
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        let dir = documents.appendingPathComponent("MinestagramImageCache", isDirectory: true)
        guard fileManager.fileExists(atPath: dir.path),
              let names = try? fileManager.contentsOfDirectory(atPath: dir.path)
        else {
            return []
        }
        return names.map { dir.appendingPathComponent($0) }
    }
}
