//
//  RemoteConfigService.swift
//  Minestagram
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigServiceProtocol: Sendable {
    func fetchAndActivateShowWhatsNew() async throws -> Bool
}

final class RemoteConfigService: RemoteConfigServiceProtocol {
    private let remoteConfig: RemoteConfig

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig
        let defaults: [String: NSObject] = [
            "showWhatsNew": true as NSObject
        ]
        remoteConfig.setDefaults(defaults)
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }

    func fetchAndActivateShowWhatsNew() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            remoteConfig.fetchAndActivate { _, error in
                DispatchQueue.main.async {
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    let value = self.remoteConfig.configValue(forKey: "showWhatsNew").boolValue
                    continuation.resume(returning: value)
                }
            }
        }
    }
}

/// Avoids touching Firebase during SwiftUI previews.
struct MockRemoteConfigService: RemoteConfigServiceProtocol {
    func fetchAndActivateShowWhatsNew() async throws -> Bool {
        false
    }
}
