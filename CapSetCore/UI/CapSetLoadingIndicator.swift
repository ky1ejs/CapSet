//
//  IconView.swift
//  CapSetCore
//
//  Created by Olly Boon on 03/08/2023.
//

import SwiftUI

public struct CapSetLoadingIndicator: View {

    @State private var rotationAngle: Angle = .degrees(0)
    private var color: Color?

    public init(color: Color? = nil) {
        self.color = color
    }

    public var body: some View {
        CapSetIcon()
            .frame(width: 40, height: 40)
            .foregroundColor(color ?? .primary)
            .rotationEffect(rotationAngle)

            .animation(Animation.interpolatingSpring(stiffness: 250, damping: 13)
                        .repeatForever(autoreverses: false), value: rotationAngle)
            .onAppear {
                withAnimation {
                    rotationAngle = .degrees(+45)

                }
            }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        CapSetLoadingIndicator()
    }
}
