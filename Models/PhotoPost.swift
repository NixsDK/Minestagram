//
//  PhotoPost.swift
//  Minestagram
//

import Foundation

/// Row model for the Photos tab (user + image).
struct PhotoPost: Identifiable, Hashable {
    let id: Int
    let username: String
    let avatarURL: URL?
    /// Asset catalog imageset name; takes precedence over `avatarURL` when set.
    let avatarAssetName: String?
    let remoteImageURL: URL
    /// Populated after sequential cache load succeeds.
    var localImageURL: URL?
}
