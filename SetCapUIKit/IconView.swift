//
//  IconView.swift
//  SetCapUIKit
//
//  Created by Olly Boon on 03/08/2023.
//

import SwiftUI

struct IconView: View {

    @State private var rotationAngle: Angle = .degrees(0)

    var body: some View {
        ScallopIcon()
            .frame(width: 40, height: 40)
            .foregroundColor(.primary)
            .rotationEffect(rotationAngle)

            .animation(Animation.interpolatingSpring(stiffness: 250, damping: 13)
                        .repeatForever(autoreverses: false), value: rotationAngle)
            .onAppear {
                withAnimation {
                    rotationAngle = .degrees(+45)

                }
            }
    }

    struct IconView_Previews: PreviewProvider {
        static var previews: some View {
            IconView()
        }
    }

    struct ScallopIcon: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let width = rect.size.width
            let height = rect.size.height
            // swiftlint:disable line_length
            path.move(to: CGPoint(x: 0.90248*width, y: 0.66987*height))
            path.addCurve(to: CGPoint(x: 0.847*width, y: 0.85355*height), control1: CGPoint(x: 0.9145*width, y: 0.73438*height), control2: CGPoint(x: 0.89601*width, y: 0.80362*height))
            path.addCurve(to: CGPoint(x: 0.66671*width, y: 0.91008*height), control1: CGPoint(x: 0.79799*width, y: 0.90348*height), control2: CGPoint(x: 0.73003*width, y: 0.92233*height))
            path.addCurve(to: CGPoint(x: 0.5*width, y: height), control1: CGPoint(x: 0.63044*width, y: 0.96436*height), control2: CGPoint(x: 0.5693*width, y: height))
            path.addCurve(to: CGPoint(x: 0.33328*width, y: 0.91008*height), control1: CGPoint(x: 0.43069*width, y: height), control2: CGPoint(x: 0.36955*width, y: 0.96436*height))
            path.addCurve(to: CGPoint(x: 0.15299*width, y: 0.85355*height), control1: CGPoint(x: 0.26996*width, y: 0.92233*height), control2: CGPoint(x: 0.202*width, y: 0.90349*height))
            path.addCurve(to: CGPoint(x: 0.09751*width, y: 0.66986*height), control1: CGPoint(x: 0.10398*width, y: 0.80362*height), control2: CGPoint(x: 0.08549*width, y: 0.73437*height))
            path.addCurve(to: CGPoint(x: 0.00926*width, y: 0.5*height), control1: CGPoint(x: 0.04424*width, y: 0.6329*height), control2: CGPoint(x: 0.00926*width, y: 0.57061*height))
            path.addCurve(to: CGPoint(x: 0.0975*width, y: 0.33014*height), control1: CGPoint(x: 0.00926*width, y: 0.42939*height), control2: CGPoint(x: 0.04424*width, y: 0.3671*height))
            path.addCurve(to: CGPoint(x: 0.15299*width, y: 0.14645*height), control1: CGPoint(x: 0.08548*width, y: 0.26563*height), control2: CGPoint(x: 0.10398*width, y: 0.19638*height))
            path.addCurve(to: CGPoint(x: 0.33328*width, y: 0.08992*height), control1: CGPoint(x: 0.202*width, y: 0.09651*height), control2: CGPoint(x: 0.26996*width, y: 0.07767*height))
            path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: 0.36955*width, y: 0.03564*height), control2: CGPoint(x: 0.43069*width, y: 0))
            path.addCurve(to: CGPoint(x: 0.66671*width, y: 0.08992*height), control1: CGPoint(x: 0.5693*width, y: 0), control2: CGPoint(x: 0.63044*width, y: 0.03564*height))
            path.addCurve(to: CGPoint(x: 0.847*width, y: 0.14645*height), control1: CGPoint(x: 0.73003*width, y: 0.07767*height), control2: CGPoint(x: 0.79799*width, y: 0.09652*height))
            path.addCurve(to: CGPoint(x: 0.90249*width, y: 0.33013*height), control1: CGPoint(x: 0.89601*width, y: 0.19638*height), control2: CGPoint(x: 0.9145*width, y: 0.26562*height))
            path.addCurve(to: CGPoint(x: 0.99074*width, y: 0.5*height), control1: CGPoint(x: 0.95576*width, y: 0.36709*height), control2: CGPoint(x: 0.99074*width, y: 0.42938*height))
            path.addCurve(to: CGPoint(x: 0.90248*width, y: 0.66987*height), control1: CGPoint(x: 0.99074*width, y: 0.57062*height), control2: CGPoint(x: 0.95576*width, y: 0.63291*height))
            // swiftlint:enable line_length
            path.closeSubpath()
            return path
        }
    }
}
