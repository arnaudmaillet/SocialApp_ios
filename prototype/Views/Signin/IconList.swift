//
//  IconListView.swift
//  prototype
//
//  Created by Arnaud Maillet on 23/02/2025.
//

import SwiftUI

struct IconListView: View {
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            ForEach(Array(icons.enumerated()), id: \.element.id) { index, icon in
                Image(systemName: icon.systemName)
                    .font(.system(size: 48))
                    .foregroundStyle(.white.shadow(.drop(radius: 10)))
                    .frame(width: 64, height: 64)
                    .background(icon.backgroundColor, in: .rect(cornerRadius: 16))
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    .scaleEffect(isVisible ? icon.scale : 0)
                    .offset(x: isVisible ? icon.offsetX : UIScreen.main.bounds.width)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.spring(response: 1, dampingFraction: 0.6, blendDuration: 0)
                        .delay(Double(index) * 0.1), value: isVisible)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            isVisible = true
        }
    }
}

#Preview {
    IconListView()
}
