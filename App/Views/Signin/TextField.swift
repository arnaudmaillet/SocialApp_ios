//
//  TextField.swift
//  prototype
//
//  Created by Arnaud Maillet on 23/02/2025.
//

import SwiftUI

struct TextFieldView: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var isSecure: Bool
    var animationDelay: Double = 0
    
    @State private var isVisible = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray.opacity(0.8))
                .scaleEffect(isFocused ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.3), value: isFocused)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .focused($isFocused)
                    .frame(height: 20)
            } else {
                TextField(placeholder, text: $text)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .focused($isFocused)
                    .frame(height: 20)
            }
        }
        .padding()
        .background(isFocused ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(8)
        .foregroundColor(.black)
        .scaleEffect(isVisible ? 1.0 : 2)
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
    @Previewable @State var email = ""
    return TextFieldView(icon: "envelope", placeholder: "Email", text: $email, isSecure: false, animationDelay: 0)
}
