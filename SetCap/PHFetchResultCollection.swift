//
//  PHFetchResultCollection.swift
//  SetCap
//
//  Created by Kyle Satti on 7/31/23.
//

import Photos

struct PHFetchResultCollection<T>: RandomAccessCollection, Equatable where T: AnyObject {
    typealias Index = Int

    var fetchResult: PHFetchResult<T>
    var endIndex: Int { fetchResult.count }
    var startIndex: Int { 0 }

    subscript(position: Int) -> T {
        fetchResult.object(at: fetchResult.count - position - 1)
    }
}
