//
//  ImageMetadata.swift
//  SetCap
//
//  Created by Kyle Satti on 5/22/23.
//

import CoreImage
import ImageIO

private struct ParsedExifData {
    let fNumber: NSNumber?
    let shutterSpeed: String?
    let iso: NSNumber?
    let maxAperture: NSNumber?
    let focalLength: NSNumber?
    let focalLength35mmEquivalent: NSNumber?

    init(_ exif: [CFString: Any]?) {
        guard let exif = exif else {
            fNumber = nil
            shutterSpeed = nil
            iso = nil
            maxAperture = nil
            focalLength = nil
            focalLength35mmEquivalent = nil
            return
        }

        fNumber = exif.get(kCGImagePropertyExifFNumber)

        if let exposureTime = exif[kCGImagePropertyExifExposureTime] as? NSNumber {
            shutterSpeed = formatShutterSpeed(exposureTime.doubleValue)
        } else {
            shutterSpeed = nil
        }

        if let isoRatings: [NSNumber] = exif.get(kCGImagePropertyExifISOSpeedRatings) {
            iso = isoRatings.first
        } else {
            iso = nil
        }

        maxAperture = exif.get(kCGImagePropertyExifMaxApertureValue)
        focalLength = exif.get(kCGImagePropertyExifFocalLength)
        focalLength35mmEquivalent = exif.get(kCGImagePropertyExifFocalLenIn35mmFilm)
    }
}

private struct ParsedExifAuxData {
    let lens: String?

    init(_ exifAux: [CFString: Any]?) {
        guard let exifAux = exifAux else {
            lens = nil
            return
        }
        lens = exifAux.get(kCGImagePropertyExifLensModel)
    }
}

private struct ParsedTiffData {
    let body: String?

    init(_ tiff: [CFString: Any]?) {
        guard let tiff = tiff else {
            body = nil
            return
        }
        let body: String? = tiff.get(kCGImagePropertyTIFFModel)
        self.body = cameraBodies[body ?? ""] ?? body
    }
}

public struct ImageMetadata {
    public var fNumber: NSNumber? { return exifData.fNumber }
    public var shutterSpeed: String? { return exifData.shutterSpeed }
    public var iso: NSNumber? { return exifData.iso }
    public var maxAperture: NSNumber? { return exifData.maxAperture }
    public var focalLength: NSNumber? { return exifData.focalLength }
    public var focalLength35mmEquivalent: NSNumber? { return exifData.focalLength35mmEquivalent }
    public var exposureCompensation: NSNumber? { return exifData.focalLength35mmEquivalent }

    public var lens: String? { return exifAuxData.lens}

    public var body: String? { return tiffData.body }

    fileprivate let exifData: ParsedExifData
    fileprivate let exifAuxData: ParsedExifAuxData
    fileprivate let tiffData: ParsedTiffData

    public init(imageData: Data) {
        let props = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let metadata = CGImageSourceCopyPropertiesAtIndex(props, 0, nil) as? [CFString: Any]
        exifData = ParsedExifData(metadata?.get(kCGImagePropertyExifDictionary))
        exifAuxData = ParsedExifAuxData(metadata?.get(kCGImagePropertyExifAuxDictionary))
        tiffData = ParsedTiffData(metadata?.get(kCGImagePropertyTIFFDictionary))
    }
}

// Helper for accessing values in a dictionary keyed by `CFString` by passing a `String`
private extension Dictionary where Key == String {
    func get(_ k: CFString) -> [CFString: Any]? {
        return self[String(k)] as? [CFString: Any]
    }
}

// Helper for casting value in a dictionary
private extension Dictionary where Key == CFString {
    func get<T>(_ k: Key) -> T? {
        return self[k] as? T
    }
}

func formatShutterSpeed(_ exposureTime: Double) -> String {
    if exposureTime >= 0.4 {
        return "\(exposureTime)s"
    }
    let exposureFraction = Int(1.0 / exposureTime)
    return "1/\(exposureFraction)s"
}
