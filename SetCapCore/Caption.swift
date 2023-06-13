//
//  Caption.swift
//  SetCapCore
//
//  Created by Kyle Satti on 6/11/23.
//

import Foundation

public func createCaption(with metadata: ImageMetadata) -> String {
    var template =  """
                    📷 %{body}
                    🔭 %{lens}
                    ⚙️ ƒ%{fNumber} | %{shutter_speed} | ISO %{iso}
                    """

    let metadata = [
        "body" : metadata.body!,
        "lens" : metadata.lens!,
        "fNumber" : metadata.fNumber!.stringValue,
        "shutter_speed" : metadata.shutterSpeed!.stringValue,
        "iso" : metadata.iso!.stringValue,
    ]

    let regex = try! Regex("%{(?<name>[A-Z]*_*[A-Z]*)}").ignoresCase()
    let variables = template.matches(of: regex).reversed()
    variables.forEach { match in
        let key = String(match["name"]!.substring!)
        guard let value = metadata[key] else { return }
        template.replaceSubrange(match.range, with: value)
    }

    return template

}

