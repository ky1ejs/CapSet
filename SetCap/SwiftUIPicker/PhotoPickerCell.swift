//
//  ThumbnailView.swift
//  SetCap
//
//  Created by Kyle Satti on 8/13/23.
//

import SwiftUI
import SetCapUIKit

struct PhotoPickerCell: View {
    private var assetLocalId: String

    @State private var image: UIImage?
    @EnvironmentObject var photoLibraryService: PhotoLibraryService

    init(assetLocalId: String) {
        self.assetLocalId = assetLocalId
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let image = image {
                    NavigationLink {
                        let loader = ImageLoader(assetId: assetLocalId, photoService: photoLibraryService)
                        CaptionView(loader: loader)
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: proxy.size.width,
                                height: proxy.size.width
                            )
                            .clipped()
                            .onDisappear {
                                self.image = nil
                            }
                    }
                } else {
                    Rectangle()
                        .foregroundColor(.gray)
                    ProgressView()
                }
            }.task {
                await loadImageAsset(targetSize: proxy.size)
            }
        }.aspectRatio(1, contentMode: .fill)
    }
}

extension PhotoPickerCell {
    func loadImageAsset(
        targetSize: CGSize
    ) async {
        guard let image = try? await photoLibraryService
                .fetchImage(byLocalIdentifier: assetLocalId, forSize: targetSize) else {
            image = nil
            return
        }
        self.image = image
    }
}
