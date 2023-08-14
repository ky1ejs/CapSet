//
//  ImageLoader.swift
//  SetCap
//
//  Created by Kyle Satti on 8/13/23.
//

import SetCapUIKit

struct ImageLoader: CaptionViewImageLoader {
    let assetId: PhotoLibraryService.PHAssetLocalIdentifier
    let photoService: PhotoLibraryService

    func load() async -> Data {
        // swiftlint:disable force_try
        return try! await photoService.fetchImage(byLocalIdentifier: assetId)!
        // swiftlint:enable force_try
    }
}
