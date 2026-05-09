//
//  User.swift
//  Minestagram
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: Int
    var avatarURL: String?
    /// Asset catalog name (e.g. `CoDGhost`); when set, UI prefers this over `avatarURL`.
    var bundledAvatarAssetName: String?
    var name: String?
    var company: String?
    var bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case name
        case company
        case bio
    }

    init(
        id: Int,
        avatarURL: String? = nil,
        bundledAvatarAssetName: String? = nil,
        name: String? = nil,
        company: String? = nil,
        bio: String? = nil
    ) {
        self.id = id
        self.avatarURL = avatarURL
        self.bundledAvatarAssetName = bundledAvatarAssetName
        self.name = name
        self.company = company
        self.bio = bio
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        bundledAvatarAssetName = nil
        name = try container.decodeIfPresent(String.self, forKey: .name)
        var decodedBio = try container.decodeIfPresent(String.self, forKey: .bio)

        if container.contains(.company) {
            if let companyString = try? container.decode(String.self, forKey: .company) {
                company = companyString
            } else if let nested = try? container.decode(CompanyPayload.self, forKey: .company) {
                company = nested.name
                if decodedBio == nil {
                    decodedBio = nested.catchPhrase
                }
            } else {
                company = nil
            }
        } else {
            company = nil
        }
        bio = decodedBio
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(avatarURL, forKey: .avatarURL)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(company, forKey: .company)
        try container.encodeIfPresent(bio, forKey: .bio)
    }
}

private struct CompanyPayload: Codable {
    let name: String
    let catchPhrase: String?
}
