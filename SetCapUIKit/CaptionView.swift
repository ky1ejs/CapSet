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
    @Environment(\.dismiss) private var dismiss
    private let loader: CaptionViewImageLoader

    public init(loader: CaptionViewImageLoader) {
        self.loader = loader
    }

    public var body: some View {
        ZStack {
            if let image = image, let metadata = metadata {
                VStack(alignment: .leading, spacing: 0) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                .sheet(isPresented: $showBottomSheet) {
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView {
                            MetadataView(metadata: metadata)
                        }
                        Spacer()
                    }.padding(.top, 24)
                    .presentationDetents([.height(160), .fraction(0.8)])
                    .interactiveDismissDisabled()
                    .presentationBackgroundInteraction(.enabled)
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
        }.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showBottomSheet = false
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left").font(Font.body.weight(.bold))
                    Text("Back")
                }

            }
        }.navigationBarBackButtonHidden()
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
        let bundle = Bundle(identifier: "dev.kylejs.SetCapUIKit")!
        let imageData = NSDataAsset(name: "parker", bundle: bundle)!
        CaptionView(loader: PassedImageLoader(imageData: imageData.data))
    }
}
