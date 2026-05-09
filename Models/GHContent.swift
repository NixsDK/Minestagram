//
//  GHContent.swift
//  Minestagram
//

import Foundation

struct GHContent: Codable, Identifiable, Hashable {
    var name: String?

    var id: String { name ?? UUID().uuidString }

    enum CodingKeys: String, CodingKey {
        case name
    }
}
