//
//  PhotoThumbnailView.swift
//  CapSet
//
//  Created by Kyle Satti on 7/29/23.
//

import SwiftUI
import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {
    var assetId: PhotoLibraryService.PHAssetLocalIdentifier? {
        didSet {
            guard photoService != nil else {
                fatalError("Asset ID set without photoService")
            }
            loadTask = Task {
                await fetchImage()
            }
        }
    }
    var photoService: PhotoLibraryService?
    private var loadTask: Task<(), Never>?
    private var state = PhotoCollectionViewCellContent.State()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentConfiguration = UIHostingConfiguration { [unowned self] in
            PhotoCollectionViewCellContent(state: self.state)
        }.margins([.all], 0)
        backgroundColor = .red
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetchImage() async {
        guard let assetId = assetId else { return }
        state.image = try? await photoService?.fetchImage(byLocalIdentifier: assetId, forSize: frame.size)
    }

    override func prepareForReuse() {
        loadTask?.cancel()
        state.image = nil
    }
}

struct PhotoCollectionViewCellContent: View {
    @ObservedObject private var state: State

    init(state: State) {
        self.state = state
    }

    var body: some View {
        //        Color.clear
        //            .overlay {
        ZStack {
            if let image = state.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .aspectRatio(1, contentMode: .fit)
                ProgressView()
            }
        }
        //            }.clipped()
        //            .padding(0)
    }

    class State: ObservableObject {
        @Published var image: UIImage?

        init(image: UIImage? = nil) {
            self.image = image
        }
    }
}

struct PhotoThumbnailViewLoaded_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            let state = PhotoCollectionViewCellContent.State(image: UIImage(data: NSDataAsset(name: "parker")!.data)!)
            PhotoCollectionViewCellContent(state: state)
        }.frame(width: 300, height: 300).background(.red).clipped()
    }
}

struct PhotoThumbnailViewLoading_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            let state = PhotoCollectionViewCellContent.State()
            PhotoCollectionViewCellContent(state: state)
        }.frame(width: 200, height: 200).background(.red).clipped()
    }
}
