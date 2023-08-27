//
//  ThumbnailView.swift
//  SetCap
//
//  Created by Kyle Satti on 8/13/23.
//

import SwiftUI
import SetCapCore
import Photos

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
                            .environment(\.templateActions, shareActions(assetId: assetLocalId))
                    } label: {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: proxy.size.width,
                                height: proxy.size.width
                            )
                            .clipped()
                    }
                } else {
                    Rectangle()
                        .foregroundColor(.black)
                    CapSetLoadingIndicator(color: .gray)
                }
            }.onDisappear {
                self.image = nil
            }.onAppear {
                Task {
                    await loadImageAsset(targetSize: proxy.size)
                }
            }
        }.aspectRatio(1, contentMode: .fill)
    }

    func shareActions(assetId: String) -> TemplateView.Actions {
        var actions = TemplateView.Actions()

        let insta = InstagramSharing(application: UIApplication.shared)
        if insta.canPost() {
            actions.append(.shareToInstagram(handler: { caption in
                UIPasteboard.general.string = caption
                insta.postImageFromLibrary(assetId: assetId)
            }))
        }

        if let vc = UIWindow.current?.rootViewController {
            actions.append(.shareViaIos(handler: { caption in
                UIPasteboard.general.string = caption

                Task {
                    guard let image = try? await photoLibraryService.fetchImage(
                        byLocalIdentifier: assetId,
                        forSize: PHImageManagerMaximumSize
                    ) else { return }

                    DispatchQueue.main.async {
                        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                        vc.present(activityVC, animated: true)
                    }
                }
            }))
        }

        return actions
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
        withAnimation {
            self.image = image
        }
    }
}
