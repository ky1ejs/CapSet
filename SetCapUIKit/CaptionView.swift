//
//  CaptionPickerView.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI
import SetCapCore

public protocol CaptionViewImageLoader {
    func load() async -> Data
}

struct PassedImageLoader: CaptionViewImageLoader {
    let imageData: Data

    func load() async -> Data {
        return imageData
    }
}

public struct CaptionView: View {
    @State private var metadata: ImageMetadata?
    @State private var image: UIImage?
    @State private var showBottomSheet = true

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
                        .background(.blue)
                    Spacer()
                }
                .sheet(isPresented: $showBottomSheet){
                    VStack(alignment: .leading, spacing: 0) {
                        Text(metadata.body ?? "Unknown body").border(.white).background(.green)
                        VStack(alignment: .leading) {
                            Text(metadata.lens ?? "-").border(.purple).background(.yellow)
                            HStack {
                                Text(metadata.focalLength?.stringValue.appending("mm") ?? "")
                                Spacer()
                                HStack {
                                    Text("ƒ\(metadata.fNumber?.stringValue ?? "-")")
                                    Text("ISO \(metadata.iso?.stringValue ?? "")")
                                    Text(metadata.shutterSpeed ?? "")
                                }
                            }
                        }
                        Spacer()
                    }.padding(20).presentationDetents([.fraction(0.32), .fraction(0.8)]).interactiveDismissDisabled()
                }
            } else {
                ProgressView()
            }

        }.task {
            let imageData = await loader.load()
            self.image = UIImage(data: imageData)
            self.metadata = ImageMetadata(image: CIImage(data: imageData)!)
        }
    }
}

class Thing {}

struct CaptionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let bundle = Bundle(identifier: "dev.kylejs.SetCapUIKit")!
        let imageData = NSDataAsset(name: "parker", bundle: bundle)!
        CaptionView(loader: PassedImageLoader(imageData: imageData.data))
    }
}

