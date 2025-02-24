//
//  Button.swift
//  prototype
//
//  Created by Arnaud Maillet on 24/02/2025.
//

import SwiftUI

struct ButtonView: View {
    @State private var isPressed = false
    @State private var isLoading: Bool = false
    @State private var isVisible: Bool = false
    
    var isActive: Bool
    var animationDelay: Double = 0
    
    var body: some View {
        Button(action: {
            if isActive {
                // Action pour créer un compte
            } else {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView().tint(.blue)
                } else {
                    Image(systemName: isActive ? "person.fill.badge.plus" : "iphone.and.arrow.right.inward")
                        .font(.system(size: 20, weight: .semibold))
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
                    Text(isActive ? "Create an Account" : "Sign In")
                        .fontWeight(.semibold)
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
                }
            }
            .frame(height: 50)
            .foregroundColor(.blue)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: isLoading ? 1 : isPressed ? 0.8 : 0.4), value: isPressed)
        }
        .padding(.horizontal)
        .disabled(isLoading)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .opacity(isVisible ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isActive)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isVisible)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ButtonView(isActive: true)
}
