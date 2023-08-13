//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Kyle Satti on 6/12/23.
//

import UIKit
import Social
import SwiftUI
import UniformTypeIdentifiers
import SetCapUIKit
import Sentry

@objc(ShareViewController)
class ShareViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        #if !DEBUG
        SentrySDK.start { options in
            options.dsn = "https://637ab924a8eb9a421ea2886827f29769@o4504922846789632.ingest.sentry.io/4505625970147328"

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }
        #endif
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        let container = Container(doneAction: { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: nil)
        },
        subview: CaptionView(loader: ImageLoader(context: extensionContext!)))

        let host = UIHostingController(rootView: container)
        host.didMove(toParent: self)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
    }
}

struct Container: View {
    let doneAction: () -> Void

    let subview: any View
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Button("Done") {
                    doneAction()
                }.padding(8)
                Spacer()
            }.padding(.leading, 8).padding(.vertical, 4)
            AnyView(subview)
        }
    }
}

struct ImageLoader: CaptionViewImageLoader {
    let context: NSExtensionContext

    func load() async -> Data {
        // swiftlint:disable force_try
        if let input = context.inputItems.first as? NSExtensionItem {
            if let attachment = input.attachments?.first {
                let result = try! await attachment.loadItem(forTypeIdentifier: UTType.image.identifier)
                switch result {
                case let image as UIImage:
                    return image.jpegData(compressionQuality: 1)!
                case let data as Data:
                    return data
                case let url as URL:
                    return try! Data(contentsOf: url)
                default:
                    fatalError("Unexpected data: \(type(of: result))")
                }
            }
        }
        fatalError("Could not load data")
        // swiftlint:enable force_try
    }
}
