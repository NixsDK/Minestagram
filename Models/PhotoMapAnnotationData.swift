//
//  PhotoMapAnnotationData.swift
//  Minestagram
//

import CoreLocation
import Foundation

struct PhotoMapAnnotationData: Identifiable, Hashable {
    let id: UUID
    let title: String
    let coordinate: CLLocationCoordinate2D
    let localFileURL: URL

    init(
        id: UUID = UUID(),
        title: String,
        coordinate: CLLocationCoordinate2D,
        localFileURL: URL
    ) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.localFileURL = localFileURL
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PhotoMapAnnotationData, rhs: PhotoMapAnnotationData) -> Bool {
        lhs.id == rhs.id
    }
}
