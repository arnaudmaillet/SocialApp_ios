//
//  AnimatedText.swift
//  prototype
//
//  Created by Arnaud Maillet on 24/02/2025.
//

import SwiftUI

struct AnimatedTextView: View {
    let text: String
    var animationDelay: Double = 0
    @State private var isVisible = false

    var body: some View {
        Text(text)
            .opacity(isVisible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isVisible)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                    isVisible = true
                }
            }
    }
}

#Preview {
    AnimatedTextView(text: "Hello world !")
}
