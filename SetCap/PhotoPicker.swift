//
//  PhotoPicker.swift
//  SetCap
//
//  Created by Kyle Satti on 7/29/23.
//

import SwiftUI
import SetCapUIKit

struct PhotoPicker: View {
    @EnvironmentObject var photoLibraryService: PhotoLibraryService

    var body: some View {
        ZStack {
            libraryView
        }
    }
}

extension PhotoPicker {
    var libraryView: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: .init(.adaptive(minimum: 100), spacing: 1),
                    count: 3
                ),
                spacing: 1
            ) {
                ForEach(photoLibraryService.results, id: \.self) { asset in
                    NavigationLink {
                        CaptionView(loader: Thing(service: photoLibraryService, id: asset.localIdentifier)).navigationTitle("Photo")
                    } label: {
                        PhotoThumbnailView(assetLocalId: asset.localIdentifier)
                    }
                }
            }
        }
    }
}

struct Thing: CaptionViewImageLoader {
    let service: PhotoLibraryService
    let id: String

    func load() async -> Data {
        return try! await service.fetchImage(byLocalIdentifier: id)!
    }
}
