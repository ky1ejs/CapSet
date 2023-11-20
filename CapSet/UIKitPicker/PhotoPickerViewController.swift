//
//  PhotoPickerViewController.swift
//  CapSet
//
//  Created by Kyle Satti on 8/12/23.
//

import UIKit
import Combine
import SwiftUI
import CapSetCore
import Photos

class PhotoPickerViewController: UICollectionViewController {
    typealias CellRegisration = UICollectionView.CellRegistration<
        PhotoCollectionViewCell,
        PhotoLibraryService.PHAssetLocalIdentifier>

    private let photoService: PhotoLibraryService
    private let layout = UICollectionViewFlowLayout()
    private let itemSize: CGFloat
    private var results: PHFetchResultCollection<PHAsset>?
    private var photoSub: AnyCancellable?
    private let cellRegistration: CellRegisration
    private let collection: PHAssetCollection?

    init(photoService: PhotoLibraryService, collection: PHAssetCollection? = nil) {
        self.photoService = photoService
        itemSize = UIScreen.current!.bounds.size.width / 3
        cellRegistration = CellRegisration { cell, _, asset in
            cell.photoService = photoService
            cell.assetId = asset
        }
        self.collection = collection
        super.init(collectionViewLayout: layout)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        photoSub?.cancel()
    }

    override func viewDidLoad() {
        if let collection = collection {
            let results = PHAsset.fetchAssets(in: collection, options: nil)
            self.results = PHFetchResultCollection(fetchResult: results)
            collectionView.reloadData()
        } else {
            photoSub = photoService.$results.sink { [weak self] collection in
                self?.results = collection
                self?.collectionView.reloadData()
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let asset = results?[indexPath.row].localIdentifier else {
            fatalError("no asset for index: \(indexPath)")

        }

        return collectionView.dequeueConfiguredReusableCell(
            using: cellRegistration,
            for: indexPath,
            item: asset
        )
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let loader = ImageLoader(assetId: results![indexPath.row].localIdentifier, photoService: photoService)
        navigationController?.pushViewController(
            UIHostingController(rootView: CaptionView(loader: loader)),
            animated: true
        )
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                return window
            }
        }
        return nil
    }
}

struct PhotoPickerViewControllerSwiftUI: UIViewControllerRepresentable {
    typealias UIViewControllerType = PhotoPickerViewController
    @EnvironmentObject private var photoService: PhotoLibraryService
    let collection: PHAssetCollection?

    func makeUIViewController(context: Context) -> PhotoPickerViewController {
        return PhotoPickerViewController(photoService: photoService, collection: collection)
    }

    func updateUIViewController(_ uiViewController: PhotoPickerViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return "\(self)"
    }
}
