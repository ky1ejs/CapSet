//
//  InstagramSharing.swift
//  CapSetCore
//
//  Created by Kyle Satti on 8/26/23.
//

import UIKit

public class InstagramSharing {
    private weak var application: UIApplication?

    private static let INSTAGRAM_DEEP_LINK_BASE = URL(string: "instagram://library")!

    public init(application: UIApplication? = nil) {
        self.application = application
    }

    public func canPost() -> Bool {
        guard let application = application else {
            return false
        }
        return application.canOpenURL(type(of: self).INSTAGRAM_DEEP_LINK_BASE)
    }

    private enum DeepLinkArg {
        case photoLibrary(id: String)
        case file(path: String)

        var queryItem: URLQueryItem {
            switch self {
            case .photoLibrary(let id):
                return URLQueryItem(name: "LocalIdentifier", value: id)
            case .file(let path):
                return URLQueryItem(name: "AssetPath", value: path)
            }
        }
    }

    public func postImageFromLibrary(assetId: String) {
        post(.photoLibrary(id: assetId))
    }

    public func postImageAtPath(path: String) {
        post(.file(path: path))
    }

    private func post(_ arg: DeepLinkArg) {
        guard canPost() else {
            fatalError("Called post to instagram but Instagram not installed on device")
        }
        let deepLink = type(of: self).INSTAGRAM_DEEP_LINK_BASE
            .appending(queryItems: [arg.queryItem])
        application!.perform(#selector(openURL), with: deepLink)
    }

    @objc private func openURL(_ url: URL) -> Bool {
        return false
    }
}
