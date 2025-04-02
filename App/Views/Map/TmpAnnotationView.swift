//
//  FakeAnnotationView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/03/2025.
//

import SwiftUI

struct TmpAnnotationView: View {
    let title: String?
    let blurStyle: UIBlurEffect.Style
    
    init(_ title: String?, blurStyle: UIBlurEffect.Style = .systemThickMaterial) {
        self.title = title
        self.blurStyle = blurStyle
    }
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        if let title = title {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.horizontal, 6.67)
                .padding(.vertical, 3.33)
                .background(
                    VisualBlurEffect(blurStyle)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                )
                .opacity(0.1)
        } else {
            EmptyView()
        }
    }
}
