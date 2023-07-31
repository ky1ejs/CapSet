//
//  MetadataView.swift
//  SetCapUIKit
//
//  Created by Olly Boon on 30/07/2023.
//

import SwiftUI
import SetCapCore

struct PillView: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.custom("SF Compact", size: 16 ))
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            .cornerRadius(6)
    }
}

struct MetadataView: View {
    let metadata: ImageMetadata

    private static let CORNER_RADIUS = CGFloat(6)
    
    var body: some View {
        
        VStack{
            HStack() {
                Text(metadata.body ?? "-")
                    .font(.system(size: 16.0, weight: .medium, design: .rounded))
                    
                Spacer()
                PillView("RAW")

            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial)
            
            HStack() {
                if let lens = metadata.lens {
                    Text(lens)
                        .font(.system(size: 16.0))
                        .foregroundColor(.secondary)
                } else {
                    Text("-")
                        .font(.system(size: 16.0))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Missing Info")
                        .font(.system(size: 16.0))
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding(8)
            
            HStack() {
                PillView("\(metadata.focalLength?.stringValue ?? "-")mm")
                Spacer()
                PillView("ƒ\(metadata.fNumber?.stringValue ?? "-")")
                Spacer()
                PillView("EV")
                Spacer()
                PillView("ISO \(metadata.iso?.stringValue ?? "-")")
                Spacer()
                PillView(metadata.shutterSpeed ?? "-")
            }
            .frame(alignment: .topLeading)
            .padding(8)
            
            
            
            
        }
        .background(.ultraThinMaterial)
        .cornerRadius(6)
        .padding(.horizontal, 16)
    }
}



struct MetadataView_Previews: PreviewProvider {

    static var previews: some View {
        let bundle = Bundle(identifier: "dev.kylejs.SetCapUIKit")!
        let imageData = NSDataAsset(name: "parker", bundle: bundle)!
        let metadata = ImageMetadata(image: CIImage(data: imageData.data)!)
        MetadataView(metadata: metadata)
    }
}
