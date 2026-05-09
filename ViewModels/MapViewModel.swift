//
//  MapViewModel.swift
//  Minestagram
//

import CoreLocation
import Foundation

@MainActor
final class MapViewModel: ObservableObject {
    @Published private(set) var annotations: [PhotoMapAnnotationData] = []
    @Published var selectedPin: PhotoMapAnnotationData?
    @Published var showDirectionsDialog = false

    func refreshAnnotations() {
        let urls = ImageCacheService.allCachedImageFileURLs()
        var found: [PhotoMapAnnotationData] = []
        for url in urls {
            guard Self.isLikelyImage(url: url) else { continue }
            guard let coord = EXIFService.coordinateIfAvailable(at: url) else { continue }
            let title = url.deletingPathExtension().lastPathComponent
            found.append(
                PhotoMapAnnotationData(
                    title: title.isEmpty ? "Photo" : title,
                    coordinate: coord,
                    localFileURL: url
                )
            )
        }
        annotations = found
    }

    func userSelectedPinForDirections(_ pin: PhotoMapAnnotationData) {
        selectedPin = pin
        showDirectionsDialog = true
    }

    func mapsDirectionsURL(for pin: PhotoMapAnnotationData) -> URL {
        let lat = pin.coordinate.latitude
        let lon = pin.coordinate.longitude
        let s = "maps://?saddr=&daddr=\(lat),\(lon)"
        return URL(string: s)!
    }

    private static func isLikelyImage(url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return ["jpg", "jpeg", "png", "heic", "tif", "tiff", "gif"].contains(ext)
    }
}
