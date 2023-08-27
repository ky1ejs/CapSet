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
                    let loader = ImageLoader(assetId: assetLocalId, photoService: photoLibraryService)
                    NavigationLink {
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
                    }.contextMenu(menuItems: {
                        NavigationLink {
                            CaptionView(loader: loader)
                                .environment(\.templateActions, shareActions(assetId: assetLocalId))
                        } label: {
                            Text("open")
                        }
                        Button("Copy last used caption (\"emoji\")") {

                        }
                        Button("Post to instagram with last used emoji") {

                        }
                        Button("Share") {

                        }
                    }) {

                            CaptionPreview(assetId: assetLocalId)
                                .environmentObject(photoLibraryService)
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

struct CaptionPreview: View {
    @State private var imageMetadata: ImageMetadata?
    @State private var image: UIImage?
    @EnvironmentObject var photoLibraryService: PhotoLibraryService

    let assetId: String

    var body: some View {
        VStack {
            if let imageMetadata = imageMetadata, let image = image {
                let name = Template.emoji.name
                let caption = CaptionBuilder.build(.emoji, with: imageMetadata)

                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .fixedSize(horizontal: false, vertical: true)
                TemplateView(templateTitle: name, caption: caption)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 140)
            } else {
                CapSetLoadingIndicator()
            }
        }.task {
            if let data = try? await photoLibraryService.fetchImage(byLocalIdentifier: assetId) {
                imageMetadata = ImageMetadata(imageData: data)
                image = UIImage(data: data)
            }
        }
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
