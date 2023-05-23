//
//  ImageMetadata.swift
//  SetCap
//
//  Created by Kyle Satti on 5/22/23.
//

import CoreImage
import ImageIO


struct ImageMetadata {
    let fNumber: NSNumber
    let body: String
    let lens: String
    
    init(image: CIImage) {
        let exif = image.properties.get(kCGImagePropertyExifDictionary)
        let exifAux = image.properties.get(kCGImagePropertyExifAuxDictionary)
        let tiff = image.properties.get(kCGImagePropertyTIFFDictionary)
        fNumber = exif.get(kCGImagePropertyExifFNumber)
        body = tiff.get(kCGImagePropertyTIFFModel)
        lens = exifAux.get(kCGImagePropertyExifLensModel)
    }
}

private extension Dictionary where Key == String {
    func get(_ k: CFString) -> [CFString: Any] {
        return self[String(k)] as! [CFString : Any]
    }

}

private extension Dictionary where Key == CFString {
    func get<T>(_ k: Key) -> T {
        return self[k] as! T
    }
}
