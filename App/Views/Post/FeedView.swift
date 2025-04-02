//
//  Feed.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/03/2025.
//

import SwiftUI

struct FeedView: View {
    @State private var player = AVPlayer()
    @State private var activePostId: UUID? = UUID()
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(Array(mockFeed.posts.enumerated()), id: \.element.id) { index, post in
                    PostView(
                        post: post,
                        postIndex: index,
                        isActive: Binding(
                            get: { activePostId == post.id },
                            set: { _ in }
                        )
                    )
                    .tag(post.id)
                    .containerRelativeFrame(.vertical, alignment: .center)
                }
            }
        }
        .ignoresSafeArea()
        .scrollTargetLayout()
        .scrollTargetBehavior(.paging)
        .scrollBounceBehavior(.basedOnSize)
        .scrollPosition(id: $activePostId)
        .onAppear {
            UIScrollView.appearance().bouncesVertically = false
            UIScrollView.appearance().delaysContentTouches = false
            if let first = mockFeed.posts.first {
                activePostId = first.id
            }
        }
        .onDisappear{
            UIScrollView.appearance().bouncesVertically = true
            UIScrollView.appearance().delaysContentTouches = true
        }
    }
}

#Preview {
    FeedView()
}
