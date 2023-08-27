//
//  CaptionPickerView.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI

public struct CaptionView: View {
    @State private var metadata: ImageMetadata?
    @State private var image: UIImage?
    private let loader: CaptionViewImageLoader

    public init(loader: CaptionViewImageLoader) {
        self.loader = loader
    }

    public var body: some View {
        VStack {
            if let image = image, let metadata = metadata {
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 30)
                        HStack(alignment: .top, spacing: 22) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(.bottom, 18)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(metadata.body ?? "-").font(.system(size: 20))
                                Text(metadata.lens ?? "-").font(.system(size: 14))
                                HStack {
                                    let metadataItems = [
                                        metadata.formattedAperture,
                                        metadata.formattedIso,
                                        metadata.shutterSpeed,
                                        metadata.formattedFocalLength,
                                        metadata.formattedExposureCompensation
                                    ].compactMap { $0 }
                                    LineSparatedView(labels: metadataItems)

                                }.padding(0)
                                NavigationLink(destination: AllMetadataView(metadata: metadata)) {
                                    Text("view all metadata").font(.system(size: 12)).foregroundColor(.gray)
                                        .padding(.top, 12)
                                }
                            }
                        }
                        .frame(maxHeight: 150)
                        .padding(.top, 4)
                        .padding(.bottom, 8)
                        Text("Choose a template")
                            .fontWeight(.medium)
                            .foregroundColor(Color.primary)
                            .padding()

                        VStack(spacing: 16) {
                            ForEach(Template.allCases) { template in
                                TemplateView(
                                    templateTitle: template.name,
                                    caption: CaptionBuilder.build(template, with: metadata))
                            }
                        }
                        Color(.clear).frame(height: 100)
                    }
                }
            } else {
                CapSetLoadingIndicator()
                Text("loading")
                    .fontSize(12)
                    .foregroundColor(.gray)
            }

        }.task {
            let imageData = await loader.load()
            withAnimation {
                self.image = UIImage(data: imageData)
                self.metadata = ImageMetadata(imageData: imageData)
            }
        }
        .navigationTitle("Choose Caption")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}

public protocol CaptionViewImageLoader {
    func load() async -> Data
}

struct LineSparatedView: View {
    let labels: [String]

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<labels.count * 2, id: \.self) { i in
                if i % 2 == 0 {
                    Text(labels[i/2]).font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 0)
                        .padding(.vertical, 2)
                } else if i != labels.count * 2 - 1 {
                    Divider().padding(.horizontal, 0)
                }
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
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
        NavigationStack {
            CaptionView(loader: PassedImageLoader(imageData: data))
        }
    }
}
