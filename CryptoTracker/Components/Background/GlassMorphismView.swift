//
//  GlassMorphismView.swift
//  CryptoTracker
//
//  Created by Leo Kim on 24/10/2021.
//

import SwiftUI

struct GlassMorphismView: View {
    var body: some View {
        ZStack {
            // Gloss background
            GeometryReader { proxy in

                let size = proxy.size

                Circle()
                    .fill(Color.purple)
                    .padding(50)
                    .blur(radius: 100)
                // moving to top left
                    .offset(x: -size.width / 1.8, y: -size.height / 5)

                // Slightly darkening
                Color.black
                    .opacity(0.7)
                    .blur(radius: 200)
                    .ignoresSafeArea()

                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .padding(50)
                    .blur(radius: 90)
                // moving to top right
                    .offset(x: size.width / 1.8, y: -size.height / 2)

                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .padding(50)
                    .blur(radius: 90)
                // moving to top right
                    .offset(x: size.width / 1.8, y: size.height / 2)

                Circle()
                    .fill(Color.purple)
                    .padding(100)
                    .blur(radius: 50)
                // moving to top left
                    .offset(x: size.width / 1.8, y: size.height / 2)

                Circle()
                    .fill(Color.purple)
                    .padding(100)
                    .blur(radius: 70)
                // moving to top left
                    .offset(x: -size.width / 1.8, y: size.height / 2)
            }
        }
    }
}

struct GlassMorphismView_Previews: PreviewProvider {
    static var previews: some View {
        GlassMorphismView()
    }
}
