//
//  PhotoPicker.swift
//  SetCap
//
//  Created by Kyle Satti on 8/13/23.
//

import SwiftUI
import Photos

struct PhotoPicker: View {
    let collection: PHAssetCollection
    @State private var assets: PHFetchResultCollection<PHAsset> = .init(fetchResult: .init())

    var body: some View {
        ZStack {ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: .init(.flexible(minimum: 100), spacing: 1),
                    count: 3
                ),
                spacing: 1
            ) {
                ForEach(assets, id: \.localIdentifier) { asset in
                    PhotoPickerCell(assetLocalId: asset.localIdentifier)
                }
            }.task {
                assets = PHFetchResultCollection(fetchResult: PHAsset.fetchAssets(in: collection, options: nil))
            }
        }
        }
    }
}
