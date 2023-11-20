//
//  SwiftUIDevResources.swift
//  CapSetCore
//
//  Created by Kyle Satti on 8/14/23.
//

import UIKit

struct SwiftUIDevResources {
    static func loadExampleImageData() -> Data {
        let bundle = Bundle(identifier: "dev.kylejs.SetCapCore")!
        let imageData = NSDataAsset(name: "parker", bundle: bundle)!
        return imageData.data
    }
}
