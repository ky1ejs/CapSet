//
//  App.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI
import Photos

struct AuthenticationState {
    var state: PHAuthorizationStatus
}

@main
struct SetCapApp: App {
    @State var state: AuthenticationState = AuthenticationState(state: PHPhotoLibrary.authorizationStatus(for: .readWrite))

    var body: some Scene {
        WindowGroup {
            if state.state == .authorized {
                VStack{ Text("Yay")}
            } else {
                PhotosPermissionView(state: $state)
            }
        }
    }
}

