//
//  App.swift
//  CapSet
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI
import Sentry

@main
struct CapSetApp: App {
    @ObservedObject private var service = PhotoLibraryService()

    init() {
        #if !DEBUG
        SentrySDK.start { options in
            options.dsn = "https://637ab924a8eb9a421ea2886827f29769@o4504922846789632.ingest.sentry.io/4505625970147328"

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            if service.authState == .authorized {
                NavigationStack {
                    AlbumPicker()
                }.environmentObject(service)
            } else {
                PhotosPermissionView().environmentObject(service)
            }
        }
    }
}
