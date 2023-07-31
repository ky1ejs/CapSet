//
//  PhotoThumbnailView.swift
//  SetCap
//
//  Created by Kyle Satti on 7/29/23.
//

import SwiftUI
import Photos

struct PhotoThumbnailView: View {
    @EnvironmentObject var photoLibraryService: PhotoLibraryService
    @State private var image: Image?

    private var assetLocalId: String

    init(assetLocalId: String) {
        self.assetLocalId = assetLocalId
    }

    var body: some View {
            ZStack {
                // Show the image if it's available
                if let image = image {
                    GeometryReader { proxy in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: proxy.size.width,
                                height: proxy.size.width
                            )
                            .clipped()
                    }
                    // We'll also make sure that the photo will
                    // be square
                    .aspectRatio(1, contentMode: .fit)
                } else {
                    // Otherwise, show a gray rectangle with a
                    // spinning progress view
                    Rectangle()
                        .foregroundColor(.gray)
                        .aspectRatio(1, contentMode: .fit)
                    ProgressView()
                }
            }
            // We need to use the task to work on a concurrent request to
            // load the image from the photo library service, which
            // is asynchronous work.
            .task {
                await loadImageAsset()
            }
            // Finally, when the view disappears, we need to free it
            // up from the memory
            .onDisappear {
                image = nil
            }
        }
}

extension PhotoThumbnailView {
    func loadImageAsset(
        targetSize: CGSize = PHImageManagerMaximumSize
    ) async {
            guard let imageData = try? await photoLibraryService
            .fetchImage(
                byLocalIdentifier: assetLocalId
            ) else {
                image = nil
                return
            }
        image = Image(uiImage: UIImage(data: imageData)!)
    }
}

//struct PhotoThumbnailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoThumbnailView()
//    }
//}
