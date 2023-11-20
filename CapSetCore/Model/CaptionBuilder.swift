//
//  Caption.swift
//  CapSetCore
//
//  Created by Kyle Satti on 6/11/23.
//

import Foundation

public struct CaptionBuilder {
    public static func build(_ template: Template, with metadata: ImageMetadata) -> String {
        var templateCopy = template.rawValue

        var values = [
            "body": metadata.body ?? "-",
            "lens": metadata.lens ?? "-",
            "fNumber": metadata.fNumber?.stringValue ?? "-",
            "shutter_speed": metadata.shutterSpeed ?? "-",
            "iso": metadata.iso?.stringValue ?? "-"
        ]

        if let focalLength = metadata.focalLength35mmEquivalent {
            values["focal_length"] =  "\(focalLength)mm"
        } else {
            values["focal_length"] =  "-"
        }

        // swiftlint:disable force_try
        let regex = try! Regex("%{(?<name>[A-Z]*_*[A-Z]*)}").ignoresCase()
        // swiftlint:enable force_try

        let variables = templateCopy.matches(of: regex).reversed()
        variables.forEach { match in
            let key = String(match["name"]!.substring!)
            guard let value = values[key] else { return }
            templateCopy.replaceSubrange(match.range, with: value)
        }

        return templateCopy
    }
}
