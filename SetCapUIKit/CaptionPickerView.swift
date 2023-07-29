//
//  CaptionPickerView.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI
import SetCapCore

public struct CaptionPickerView: View {
    private let image: UIImage
    private let metadata: ImageMetadata

    @State private var showBottomSheet = true

    public init(imageData: Data) {
        self.image = UIImage(data: imageData)!
        metadata = ImageMetadata(image: CIImage(data: imageData)!)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .background(.blue)
            Spacer()
        }.ignoresSafeArea(edges: .top)
            .sheet(isPresented: $showBottomSheet) {
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

    }
}

class Thing {}

struct CaptionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let bundle = Bundle(identifier: "dev.kylejs.SetCapUIKit")!
        let imageData = NSDataAsset(name: "parker", bundle: bundle)
        CaptionPickerView(imageData: imageData!.data)
    }
}

