//
//  SwiftUIView.swift
//  CapSet
//
//  Created by Olly Boon on 28/07/2023.
//

import SwiftUI
import Photos

struct PhotosPermissionView: View {
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var translation: CGSize = .zero
    @State private var isDragging = false
    @EnvironmentObject private var photoService: PhotoLibraryService

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                translation = value.translation
                isDragging = true
            }
            .onEnded { _ in
                withAnimation {
                    translation = .zero
                    isDragging = false
                }
            }

    }

    let symbolSize = CGFloat(32)
    let opacity = CGFloat(0.7)

    var body: some View {

        VStack {
            ZStack {
                Text("CapSet needs permission to use your photo library")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)

            }

            ZStack {

                Color("Background")
                    .overlay(
                        ZStack {

                            HStack(alignment: .center) {
                                Image(systemName: "p.square.fill")
                                Spacer()
                                Image(systemName: "bolt.fill")
                                    .rotationEffect(.degrees(180))
                            }
                            .font(.system(size: symbolSize))
                            .padding(symbolSize)
                            .frame(width: 300, height: 110)
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(linearGradient)
                            )
                            .overlay(glassEffect)
                            .opacity(opacity)
                            .cornerRadius(100)
                            .background(pillShadow)
                            .offset(x: translation.width/50, y: translation.height/50)

                            HStack(alignment: .center) {
                                Image(systemName: "figure.run")
                                Spacer()
                                Image(systemName: "m.square.fill")
                                    .rotationEffect(.degrees(180))

                            }
                            .font(.system(size: symbolSize))
                            .padding(symbolSize)
                            .frame(width: 300, height: 110)
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(linearGradient)
                            )
                            .overlay(glassEffect)
                            .opacity(opacity)
                            .cornerRadius(100)
                            .background(pillShadow)
                            .offset(x: translation.width/40, y: translation.height/40)
                            .rotationEffect(.degrees(90))

                            HStack(alignment: .center) {
                                Image(systemName: "moon.stars")
                                Spacer()
                                // Image(systemName: "p.square.fill")
                                Text("AUTO")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .rotationEffect(.degrees(180))
                                    .dynamicTypeSize(.medium ... .xxLarge)

                            }
                            .font(.system(size: symbolSize))
                            .padding(symbolSize)
                            .frame(width: 300, height: 110)
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(linearGradient)
                            )
                            .overlay(glassEffect)
                            .opacity(opacity)
                            .cornerRadius(100)
                            .background(pillShadow)
                            .offset(x: translation.width/25, y: translation.height/25)
                            .rotationEffect(.degrees(45))

                            HStack(alignment: .center) {
                                Image(systemName: "camera.macro")
                                Spacer()
                                Image(systemName: "s.square.fill")
                                    .rotationEffect(.degrees(180))
                            }
                            .font(.system(size: symbolSize))
                            .padding(symbolSize)
                            .frame(width: 300, height: 110)
                            .background(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(linearGradient)
                            )
                            .overlay(glassEffect)
                            .opacity(opacity)
                            .cornerRadius(100)
                            .background(pillShadow)
                            .offset(x: translation.width/25, y: translation.height/25)
                            .rotationEffect(.degrees(135))

                        }
                        .rotationEffect(rotationAngle)
                        .animation(Animation.linear(duration: 20)
                                    .repeatForever(autoreverses: false), value: rotationAngle)
                    )

            }
            .onAppear {
                withAnimation {
                    rotationAngle = .degrees(360)
                }
            }
            .rotation3DEffect(.degrees(isDragging ? 10 : 0), axis: (x: -translation.height, y: translation.width, z: 0))
            .gesture(drag)

            HStack {
                Button {
                    photoService.requestAccess()
                } label: {
                    Text("Continue")
                        .fontWeight(.medium)
                        .foregroundColor(Color("AccentInvert"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, 24)

            }
        }

    }

    var linearGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, .white.opacity(0.5), .clear, .white.opacity(0.3), .clear],
            startPoint: .topLeading,
            endPoint: UnitPoint(
                x: abs(translation.height/25)+1,
                y: abs(translation.height/25)+1)
        )
    }

    var pillShadow: some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(.black)
            .offset(y: -10)
            .blur(radius: 20)
            .opacity(0.5)
            .blendMode(.overlay)

    }

    var glassEffect: some View {
        LinearGradient(
            colors: [.clear, .white.opacity(0.1), .clear],
            startPoint: .topLeading,
            endPoint: UnitPoint(x: abs(translation.height/100), y: abs(translation.height/100))
        )
    }

}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosPermissionView()
            .environmentObject(PhotoLibraryService())
    }
}
