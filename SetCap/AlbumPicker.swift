//
//  AlbumPicker.swift
//  SetCap
//
//  Created by Kyle Satti on 8/13/23.
//

import SwiftUI
import Photos

struct AlbumPicker: View {
    @State private var collections: [PHAssetCollection] = []

    var body: some View {
        List {
            ForEach(collections, id: \.localIdentifier) { collection in
                NavigationLink(collection.localizedTitle ?? "Album") {
                    PhotoPicker(collection: collection)
                }
            }
        }
        .task {
            let user = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .smartAlbumUserLibrary,
                options: nil)
            let favorites = PHAssetCollection.fetchAssetCollections(
                with: .smartAlbum,
                subtype: .smartAlbumFavorites,
                options: nil)
            var results: [PHAssetCollection] = []
            results += user.objects(at: IndexSet(0..<user.count))
            results += favorites.objects(at: IndexSet(0..<favorites.count))
            collections = results
        }
    }
}

struct AlbumPicker_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPicker()
    }
}
