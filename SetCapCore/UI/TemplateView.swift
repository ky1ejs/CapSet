//
//  TemplateView.swift
//  SetCapCore
//
//  Created by Kyle Satti on 8/26/23.
//

import SwiftUI
import OrderedCollections

public struct TemplateActionsKey: EnvironmentKey {
    public static let defaultValue: TemplateView.Actions? = nil
}

public extension EnvironmentValues {
    var templateActions: TemplateView.Actions? {
        get { self[TemplateActionsKey.self] }
        set { self[TemplateActionsKey.self] = newValue }
    }
}

public struct TemplateView: View {
    let templateTitle: String
    let caption: String
    @Environment(\.templateActions) var actions: Actions?

    public typealias Actions = OrderedSet<Action>
    public typealias ShareHandler = ((_ caption: String) -> Void)

    public enum Action: Hashable, Identifiable {

        public static func == (lhs: TemplateView.Action, rhs: TemplateView.Action) -> Bool {
            return lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public var id: String {
            switch self {
            case .shareToInstagram: return "instagram"
            case .shareViaIos: return "ios"
            case .copy: return "copy"
            }
        }

        var handler: ShareHandler {
            switch self {
            case let .shareToInstagram(handler):
                return handler
            case let .shareViaIos(handler):
                return handler
            case let .copy(handler):
                return handler
            }
        }

        var label: some View {
            switch self {
            case .shareToInstagram:
                let bundle = Bundle(identifier: "dev.kylejs.SetCapCore")!
                return AnyView(Image("instagram", bundle: bundle)
                                .foregroundColor(.purple)
                                .fontWeight(.bold)
                                .font(.system(size: 20)))
            case .shareViaIos:
                return AnyView(Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue))
            case .copy:
                return AnyView(Image(systemName: "doc.on.doc.fill")
                                .foregroundColor(.gray))
            }
        }

        case shareToInstagram(handler: ShareHandler)
        case shareViaIos(handler: ShareHandler)
        case copy(handler: ShareHandler)
    }

    private func buildActions() -> OrderedSet<Action> {
        var actions: OrderedSet<Action> = [.copy(handler: { caption in
            UIPasteboard.general.string = caption
        })]
        actions.append(contentsOf: self.actions ?? [])
        return actions
    }

    public var body: some View {

        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Text(templateTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.bottom, 8)
                Spacer()
                ForEach(buildActions()) { action in
                    Button {
                        action.handler(caption)
                    } label: {
                        Label(title: {
                            Text("unused")
                        }, icon: {
                            action.label
                        })
                        .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
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
