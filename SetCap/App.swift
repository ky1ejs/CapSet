//
//  App.swift
//  SetCap
//
//  Created by Kyle Satti on 7/28/23.
//

import SwiftUI
import Sentry

@main
struct SetCapApp: App {
    @ObservedObject private var service = PhotoLibraryService()

    init() {
        SentrySDK.start { options in
            options.dsn = "https://637ab924a8eb9a421ea2886827f29769@o4504922846789632.ingest.sentry.io/4505625970147328"
            options.debug = true // Enabled debug when first installing is always helpful

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }
    }

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

