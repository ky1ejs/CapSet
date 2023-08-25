//
//  CaptionPickerView.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI
import SetCapCore

public struct CaptionView: View {
    @State private var metadata: ImageMetadata?
    @State private var image: UIImage?
    @State private var showBottomSheet = false
    private let loader: CaptionViewImageLoader

    public init(loader: CaptionViewImageLoader) {
        self.loader = loader
    }

    public var body: some View {
        ZStack {
            if let image = image, let metadata = metadata {
                ScrollView {
                    VStack(spacing: 0) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding(.bottom, 18)
                        MetadataView(metadata: metadata)
                        HStack {
                            NavigationLink(
                                "view all metadata",
                                destination: AllMetadataView(metadata: metadata)
                            ).padding(.vertical, 12)
                        }
                    }
                }
            } else {
                ProgressView()
            }

        }.task {
            let imageData = await loader.load()
            self.image = UIImage(data: imageData)
            self.metadata = ImageMetadata(imageData: imageData)
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                showBottomSheet = true
            }
        }.onDisappear {
            showBottomSheet = false
        }
    }
}

public protocol CaptionViewImageLoader {
    func load() async -> Data
}

struct CaptionPickerView_Previews: PreviewProvider {
    struct PassedImageLoader: CaptionViewImageLoader {
        let imageData: Data

        func load() async -> Data {
            return imageData
        }
    }

    static var previews: some View {
        let data = SwiftUIDevResources.loadExampleImageData()
        CaptionView(loader: PassedImageLoader(imageData: data))
    }
}
