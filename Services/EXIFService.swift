//
//  EXIFService.swift
//  Minestagram
//

import CoreLocation
import Foundation
import ImageIO

struct EXIFService {
    /// Human-readable EXIF / TIFF / GPS properties for display.
    static func dictionaryForImage(at fileURL: URL) -> [String: String] {
        guard let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil) else {
            return ["Error": "Could not open image."]
        }
        guard let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else {
            return [:]
        }
        var lines: [String: String] = [:]

        if let exif = props[kCGImagePropertyExifDictionary as String] as? [String: Any] {
            lines.merge(flatten(prefix: "EXIF", dict: exif), uniquingKeysWith: { $1 })
        }
        if let tiff = props[kCGImagePropertyTIFFDictionary as String] as? [String: Any] {
            lines.merge(flatten(prefix: "TIFF", dict: tiff), uniquingKeysWith: { $1 })
        }
        if let gps = props[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
            lines.merge(flatten(prefix: "GPS", dict: gps), uniquingKeysWith: { $1 })
        }
        if let iptc = props[kCGImagePropertyIPTCDictionary as String] as? [String: Any] {
            lines.merge(flatten(prefix: "IPTC", dict: iptc), uniquingKeysWith: { $1 })
        }

        return lines
    }

    static func coordinateIfAvailable(at fileURL: URL) -> CLLocationCoordinate2D? {
        guard let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil) else { return nil }
        guard let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
              let gps = props[kCGImagePropertyGPSDictionary as String] as? [String: Any]
        else {
            return nil
        }
        guard let lat = doubleValue(gps[kCGImagePropertyGPSLatitude as String]),
              let latRef = gps[kCGImagePropertyGPSLatitudeRef as String] as? String,
              let lon = doubleValue(gps[kCGImagePropertyGPSLongitude as String]),
              let lonRef = gps[kCGImagePropertyGPSLongitudeRef as String] as? String
        else {
            return nil
        }
        var latitude = lat
        var longitude = lon
        if latRef.uppercased() == "S" { latitude *= -1 }
        if lonRef.uppercased() == "W" { longitude *= -1 }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    private static func flatten(prefix: String, dict: [String: Any]) -> [String: String] {
        var out: [String: String] = [:]
        for (key, value) in dict.sorted(by: { $0.key < $1.key }) {
            let label = "\(prefix).\(key)"
            out[label] = describe(value)
        }
        return out
    }

    private static func doubleValue(_ any: Any?) -> Double? {
        switch any {
        case let n as NSNumber:
            return n.doubleValue
        case let d as Double:
            return d
        case let f as Float:
            return Double(f)
        default:
            return nil
        }
    }

    private static func describe(_ value: Any) -> String {
        switch value {
        case let n as NSNumber:
            return n.stringValue
        case let s as String:
            return s
        case let d as [String: Any]:
            return d.map { "\($0.key): \(describe($0.value))" }.sorted().joined(separator: "; ")
        case let a as [Any]:
            return a.map { describe($0) }.joined(separator: ", ")
        default:
            return String(describing: value)
        }
    }
}
