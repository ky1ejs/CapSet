//
//  MetadataView.swift
//  CapSetCore
//
//  Created by Olly Boon on 30/07/2023.
//

import SwiftUI

struct PillView: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.custom("SF Compact", size: 12 ))
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

        VStack(alignment: .leading) {

            VStack {
                HStack {
                    Text(metadata.body ?? "-")
                        .font(.system(size: 16.0, weight: .medium, design: .rounded))

                    Spacer()
                    PillView("RAW")

                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)

                HStack {
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

                HStack {
                    PillView("\(metadata.focalLength35mmEquivalent?.stringValue ?? "-")mm")
                    Spacer()
                    PillView("ƒ\(metadata.fNumber?.stringValue ?? "-")")
                    Spacer()
                    PillView("EV \(metadata.exposureCompensation ?? 0)")
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
}

var linearGradient: LinearGradient {
    LinearGradient(
        colors: [.clear, .white.opacity(0.5), .clear, .white.opacity(0.3), .clear],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

struct MetadataView_Previews: PreviewProvider {

    static var previews: some View {
        let imageData = SwiftUIDevResources.loadExampleImageData()
        let metadata = ImageMetadata(imageData: imageData)
        MetadataView(metadata: metadata)
    }
}
