//
//  SwiftUIDevResources.swift
//  SetCapUIKit
//
//  Created by Kyle Satti on 8/14/23.
//

import UIKit

struct SwiftUIDevResources {
    static func loadExampleImageData() -> Data {
        let bundle = Bundle(identifier: "dev.kylejs.SetCapUIKit")!
        let imageData = NSDataAsset(name: "parker", bundle: bundle)!
        return imageData.data
    }
}
