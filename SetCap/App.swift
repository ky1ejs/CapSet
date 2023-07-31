//
//  App.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI

@main
struct SetCapApp: App {
    @ObservedObject private var service = PhotoLibraryService()

    var body: some Scene {
        WindowGroup {
            if service.authState == .authorized {
                NavigationStack {
                    PhotoPicker().environmentObject(service)
                }
            } else {
                PhotosPermissionView().environmentObject(service)
            }
        }
    }
}

