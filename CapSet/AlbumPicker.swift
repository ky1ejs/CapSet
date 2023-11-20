//
//  AlbumPicker.swift
//  CapSet
//
//  Created by Kyle Satti on 8/13/23.
//

import SwiftUI
import Photos
import CapSetCore

struct AlbumPicker: View {
    @State private var mainCollections: [PHAssetCollection] = []
    @State private var albums: PHFetchResultCollection<PHAssetCollection> = .init(fetchResult: .init())
    @State private var loading = true

    var body: some View {
        ZStack {
            if loading {
                VStack {
                    CapSetLoadingIndicator()
                    Text("loading")
                        .fontSize(12)
                        .foregroundColor(.gray)
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
                            mainCollections = results

                            let albums = PHAssetCollection.fetchAssetCollections(
                                with: .album,
                                subtype: .smartAlbumUserLibrary,
                                options: nil
                            )
                            self.albums = PHFetchResultCollection(fetchResult: albums)
                            withAnimation {
                                loading = false
                            }
                        }
                }
            } else {
                List {
                    Section {
                        ForEach(mainCollections, id: \.localIdentifier) { collection in
                            NavigationLink(collection.localizedTitle ?? "Album") {
                                PhotoPicker(collection: collection)
                            }
                        }
                    }
                    Section("Albums") {
                        ForEach(albums, id: \.localIdentifier) { collection in
                            NavigationLink(collection.localizedTitle ?? "Album") {
                                PhotoPicker(collection: collection)
                            }
                        }
                    }
                }
            }
        }.navigationTitle("Albums")
    }
}

struct AlbumPicker_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPicker()
    }
}
