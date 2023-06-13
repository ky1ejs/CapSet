//
//  ImageMetadata.swift
//  SetCap
//
//  Created by Kyle Satti on 5/22/23.
//

import CoreImage
import ImageIO


public struct ImageMetadata {
    let fNumber: NSNumber?
    let shutterSpeed: NSNumber?
    let iso: NSNumber?
    let body: String?
    let lens: String?
    let maxAperture: NSNumber?
    let focalLength: NSNumber?
    let focalLength35mmEquivalent: NSNumber?
    
    public init(image: CIImage) {
        let exif = image.properties.get(kCGImagePropertyExifDictionary)
        let exifAux = image.properties.get(kCGImagePropertyExifAuxDictionary)
        let tiff = image.properties.get(kCGImagePropertyTIFFDictionary)
        fNumber = exif.get(kCGImagePropertyExifFNumber)
        shutterSpeed = exif.get(kCGImagePropertyExifShutterSpeedValue)
        let isoRatings: [NSNumber] = exif.get(kCGImagePropertyExifISOSpeedRatings)
        iso = isoRatings.first
        body = tiff.get(kCGImagePropertyTIFFModel)
        lens = exifAux.get(kCGImagePropertyExifLensModel)
        maxAperture = exif.get(kCGImagePropertyExifMaxApertureValue)
        focalLength = exif.get(kCGImagePropertyExifFocalLength)
        focalLength35mmEquivalent = exif.get(kCGImagePropertyExifFocalLenIn35mmFilm)
    }
}

// Helper for accessing values in a dictionary keyed by `CFString` by passing a `String`
private extension Dictionary where Key == String {
    func get(_ k: CFString) -> [CFString: Any] {
        return self[String(k)] as! [CFString : Any]
    }
}

// Helper for casting value in a dictionary
private extension Dictionary where Key == CFString {
    func get<T>(_ k: Key) -> T {
        return self[k] as! T
    }
}
