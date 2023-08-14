//
//  PhotoLibraryService.swift
//  SetCap
//
//  Created by Kyle Satti on 7/29/23.
//

import Photos
import UIKit

enum QueryError: Error {
    case noFound
}

// Largely inspired by: https://codewithchris.com/photo-gallery-app-swiftui-part-1/
class PhotoLibraryService: ObservableObject {
    static private let ACCESS_LEVEL = PHAccessLevel.readWrite

    @Published var authState: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: ACCESS_LEVEL)
    @Published var results = PHFetchResultCollection<PHAsset>(fetchResult: .init())

    private let imageCachingManager = PHCachingImageManager.default()

    typealias PHAssetLocalIdentifier = String

    init() {
        if authState == .authorized { fetchAllPhotos() }
    }

    func fetchAllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        DispatchQueue.main.async {
            self.results.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        }
    }

    func fetchImage(byLocalIdentifier localId: PHAssetLocalIdentifier) async throws -> Data? {
        let results = PHAsset.fetchAssets(
            withLocalIdentifiers: [localId],
            options: nil
        )
        guard let asset = results.firstObject else {
            throw QueryError.noFound
        }
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            /// Use the imageCachingManager to fetch the image
            self?.imageCachingManager.requestImageDataAndOrientation(
                for: asset,
                options: options,
                resultHandler: { data, _, _, info in
                    if let error = info?[PHImageErrorKey] as? Error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: data)
                })
        }
    }

    func fetchImage(byLocalIdentifier localId: PHAssetLocalIdentifier, forSize size: CGSize) async throws -> UIImage? {
        let results = PHAsset.fetchAssets(
            withLocalIdentifiers: [localId],
            options: nil
        )
        guard let asset = results.firstObject else {
            throw QueryError.noFound
        }
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            /// Use the imageCachingManager to fetch the image
            self?.imageCachingManager.requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFill,
                options: options,
                resultHandler: { image, info in
                    if let error = info?[PHImageErrorKey] as? Error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: image)
                })
        }
    }

    func requestAccess() {
        guard authState != .authorized else { return }
        PHPhotoLibrary.requestAuthorization(for: type(of: self).ACCESS_LEVEL) { status in
            self.authState = status
            self.fetchAllPhotos()
        }
    }
}
