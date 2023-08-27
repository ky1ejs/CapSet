//
//  ShareToInsta.swift
//  SetCap
//
//  Created by Kyle Satti on 8/26/23.
//

import UIKit

@MainActor
struct Instagram {
    public static func canPost() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "instagram://app")!)
    }

    public static func postToFeed(imageId: String) {
        let urlFeed = "instagram://library?LocalIdentifier=" + imageId
        let url = URL(string: urlFeed)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            fatalError("Called post to instagram but Instagram not installed on device")
        }
    }
}
