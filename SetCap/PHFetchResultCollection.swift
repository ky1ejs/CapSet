//
//  PHFetchResultCollection.swift
//  SetCap
//
//  Created by Kyle Satti on 7/31/23.
//

import Photos

struct PHFetchResultCollection: RandomAccessCollection, Equatable {
    typealias Element = PHAsset
    typealias Index = Int

    var fetchResult: PHFetchResult<PHAsset>
    var endIndex: Int { fetchResult.count }
    var startIndex: Int { 0 }

    subscript(position: Int) -> PHAsset {
        fetchResult.object(at: fetchResult.count - position - 1)
    }
}

