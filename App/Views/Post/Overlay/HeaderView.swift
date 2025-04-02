//
//  HeaderView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 28/03/2025.
//

import SwiftUI

struct HeaderView: View {
    let post: Post
    
    var body: some View {
        VStack(spacing: 32) {
            HStack(spacing: 12) {
                Color.clear.frame(width: 12, height: 1)
                AsyncImage(url: post.author.profilePictureURL) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 40, height: 40)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.author.username)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Label("14,5k", systemImage: "person.and.background.dotted")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.85))
                }
                
                Spacer()
                
                Button("Follow") {
                    print("Follow tapped")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.85))
                .clipShape(Capsule())
                .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    PostView(
        post: PostView.previewPost(
            type: .media(Factory.randomMediaType(.photo))
        ),
        index: 0,
        isActive: .constant(true)
    )
}

