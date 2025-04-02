//
//  ContentView.swift
//  prototype
//
//  Created by Arnaud Maillet on 21/02/2025.
//

import SwiftUI
import MapKit

struct SigninView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPressed = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack (alignment: .top) {
                    MapView(animationDelay: 0)
                    IconListView(animationDelay: 0)
                }
                .padding(.vertical)
                .offset(x: -48)
            }
            .padding(.vertical)
            
            VStack(spacing: 20) {
                Spacer()
                
                TitleView(animationDelay: 0.2)
                
                // Form Stack
                VStack(spacing: 16) {
                        TextFieldView(icon: "envelope", placeholder: "Email", text: $email, isSecure: false, animationDelay: 0.2)
                        TextFieldView(icon: "lock", placeholder: "Password", text: $password, isSecure: true, animationDelay: 0.4)
                    
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            TextView(text: "Forgot your password ?", animationDelay: 0.6)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .padding()
                
                
                ButtonView(isActive: email.isEmpty || password.isEmpty, animationDelay: 0.6)
            }
        }
    }
}

// Effet de flou
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


#Preview {
    SigninView()
}
