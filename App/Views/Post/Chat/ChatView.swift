//
//  ChatView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 31/03/2025.
//

import SwiftUI
import Combine

enum MessageAlignment {
    case right
    case left
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
}

struct ChatView: View {
    let post: Post
    @Bindable var uiState: PostUIState
    @State private var messageText: String = ""
    @State private var keyboardPadding: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        Color.clear
                            .frame(height: uiState.headerSize.height)
                            .id("offset-header")
                        ForEach(post.comments) { comment in
                            MessageView(comment: comment)
                                .id(comment.id)
                        }
                        Color.clear
                            .frame(height: uiState.footerSize.height)
                            .id("offset-footer")
                    }
                }
                .onAppear {
                    // scroll automatique à l'ouverture
                    DispatchQueue.main.async {
                        proxy.scrollTo("offset-footer", anchor: .bottom)
                    }
                }
                .onChange(of: post.comments.count) {
                    withAnimation {
                        proxy.scrollTo("offset-footer", anchor: .bottom)
                    }
                }
                .padding(.horizontal)
            }
        }
        .ignoresSafeArea()
    }
}


struct MessageView: View {
    let comment: Comment
    let rightAlignment: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .bottom) {
                    AsyncImage(url: comment.author.profilePictureURL) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 40)
                    }
                    
                    Text("\(comment.author.username) ∙ \(comment.text)")
                        .padding(10)
                        .background(.gray.opacity(0.5))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
    }
}

#Preview {
    let chatRoom = Factory.randomChatRoom()
    let post = PostView.previewPost(type: .chatRoom(chatRoom))

    return PostView(
        post: post,
        index: 0,
        isActive: .constant(true)
    )
}
