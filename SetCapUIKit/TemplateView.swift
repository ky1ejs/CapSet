//
//  TemplateView.swift
//  SetCapUIKit
//
//  Created by Kyle Satti on 8/26/23.
//

import SwiftUI
import SetCapCore
import OrderedCollections

public struct TemplateActionsKey: EnvironmentKey {
    public static let defaultValue: TemplateView.Actions = nil
}

public extension EnvironmentValues {
    var templateActions: TemplateView.Actions {
        get { self[TemplateActionsKey.self] }
        set { self[TemplateActionsKey.self] = newValue }
    }
}

public struct TemplateView: View {
    let templateTitle: String
    let caption: String
    @Environment(\.templateActions) var actions: Actions

    public typealias Actions = OrderedSet<Action>?
    public typealias ShareHandler = ((_ caption: String) -> Void)

    public enum Action: Hashable, Identifiable {

        public static func == (lhs: TemplateView.Action, rhs: TemplateView.Action) -> Bool {
            return lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public var id: String {iconName}

        var handler: ShareHandler {
            switch self {
            case let .shareToInstagram(handler):
                return handler
            }
        }

        var iconName: String {
            switch self {
            case .shareToInstagram:
                return "instagram"
            }
        }

        case shareToInstagram(handler: ShareHandler)
    }

    public var body: some View {

        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Text(templateTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)
                Spacer()
                Button {
                    copyToPasteboard()
                } label: {
                    Label("Copy", systemImage: "doc.on.doc.fill")
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                if let actions = actions {
                    ForEach(actions) { a in
                        Button {
                            a.handler(caption)
                        } label: {
                            let bundle = Bundle(identifier: "dev.kylejs.SetCapUIKit")!
                            Label(title: { Text("")}, icon: {
                                Image(a.iconName, bundle: bundle)
                                    .fontWeight(.bold).font(.system(size: 20))

                            })
                            .fontWeight(.medium)
                            .foregroundColor(.purple)
                            .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
            }
            .padding([.top, .leading, .trailing])

            Text(caption)
                .padding([.leading, .bottom])

        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.secondary, lineWidth: 0.5)
        )
        .padding(.horizontal, 16)
    }

    func copyToPasteboard() {
        UIPasteboard.general.string = caption
    }
}

struct TemplateView_Previews: PreviewProvider {

    static var previews: some View {
        let data = SwiftUIDevResources.loadExampleImageData()
        let metadata = ImageMetadata(imageData: data)
        let caption = CaptionBuilder.build(.emoji, with: metadata)
        TemplateView(templateTitle: "Test", caption: caption)
            .environment(\.templateActions, [.shareToInstagram(handler: { _ in

            })])
    }
}
