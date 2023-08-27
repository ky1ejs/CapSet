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
import SetCapCore
import Sentry
import Photos

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
        let container = Container(
            applicationProvider: { [weak self] in return self?.findApplication()},
            context: extensionContext,
            presentingViewController: self
        )

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

    private func findApplication() -> UIApplication? {
        var responder: UIResponder? = self
        while responder != nil {
            if let app = responder as? UIApplication {
                return app
            }
            responder = responder?.next
        }
        return nil
    }
}

struct Container: View {
    let applicationProvider: (() -> UIApplication?)
    let context: NSExtensionContext?
    weak var presentingController: UIViewController?

    @State private var actions: TemplateView.Actions?
    @ObservedObject private var imageLoader: ImageLoader

    init(applicationProvider: @escaping () -> UIApplication?,
         context: NSExtensionContext?,
         presentingViewController: UIViewController?) {

        self.applicationProvider = applicationProvider
        self.context = context
        self.presentingController = presentingViewController
        imageLoader = ImageLoader(context: context)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Button("Done") {
                    context?.completeRequest(returningItems: nil)
                }.padding(8)
                Spacer()
            }.padding(.leading, 8).padding(.vertical, 4)
            CaptionView(loader: imageLoader)
        }
        .environment(\.templateActions, actions)
        .onAppear {
            buildTemplateActions()
        }
    }

    private func buildTemplateActions() {
        guard let vc = presentingController else { return }

        actions = [.shareViaIos(handler: { caption in
            guard let filePath = imageLoader.filePath else {
                fatalError("Sharing invoked but a file has not been set")
            }
            UIPasteboard.general.string = caption
            let imageURL = URL(string: filePath)!
            let controller = UIActivityViewController(activityItems: [imageURL], applicationActivities: nil)
            vc.present(controller, animated: true)
        })]
    }
}

@MainActor
class ImageLoader: ObservableObject, CaptionViewImageLoader {
    let context: NSExtensionContext?
    @Published var filePath: String?

    init(context: NSExtensionContext?) {
        self.context = context
    }

    func load() async -> Data {
        guard let context = context else {
            fatalError("Extension context not provided")
        }
        // swiftlint:disable force_try
        if let input = context.inputItems.first as? NSExtensionItem {
            if let attachment = input.attachments?.first {
                return await withCheckedContinuation({ continuation in
                    _ = attachment.loadFileRepresentation(
                        forTypeIdentifier: UTType.jpeg.identifier,
                        completionHandler: { [weak self] url, error in
                            guard let url = url, error == nil else {
                                fatalError("Could not load data")
                            }
                            let newPath = URL(filePath: NSTemporaryDirectory())
                                .appending(path: "insta-post").appendingPathExtension("jpeg")
                            try? FileManager.default.removeItem(at: newPath)
                            try! FileManager.default.copyItem(at: url, to: newPath)
                            DispatchQueue.main.async { [weak self] in
                                self?.filePath = newPath.absoluteString
                            }
                            continuation.resume(returning: try! Data(contentsOf: newPath))
                        })
                })
            }
        }
        fatalError("Could not load data")
        // swiftlint:enable force_try
    }
}
