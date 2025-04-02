//
//  FooterView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 28/03/2025.
//

import SwiftUI
import CoreMedia

struct FooterView: View {
    let post: Post
    @Bindable var uiState: PostUIState
    @State private var isDraggingSlider = false
    @State private var showOptions = false
    
    @Namespace private var footerAnimation
    
    let categoryLabels: [String] = [
        "🚀 Top rated",
        "🕑 Recents",
        "👑 VIP"
    ]
    
    init(post: Post, uiState: PostUIState) {
        self.post = post
        self._uiState = Bindable(wrappedValue: uiState)

        // Initialisation de showOptions
        switch post.contentType {
        case .gallery:
            self._showOptions = State(initialValue: true)
        case .media(let mediaType):
            if case .video = mediaType {
                self._showOptions = State(initialValue: true)
            } else {
                self._showOptions = State(initialValue: false)
            }
        default:
            self._showOptions = State(initialValue: false)
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if uiState.isCommentsActive {
                        ForEach(categoryLabels, id: \.self) { category in
                            Button {
                                print("\(category) tapped")
                            } label: {
                                HStack(spacing: 4) {
                                    Text(category)
                                        .foregroundStyle(.white)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                                .padding(8)
                                .background(.ultraThinMaterial.opacity(0.85))
                                .clipShape(Capsule())
                            }
                        }
                    } else {
                        Button {
                            print("❤️ tapped")
                        } label: {
                            Text("❤️")
                                .padding(8)
                                .background(.ultraThinMaterial.opacity(0.85))
                                .clipShape(Capsule())
                        }
                        
                        ForEach(Array(post.reactions.all.sorted(by: { $0.value > $1.value })), id: \.key) { element in
                            let emoji = element.key
                            let count = element.value
                            
                            Button {
                                print("\(emoji) tapped")
                            } label: {
                                HStack(spacing: 4) {
                                    Text(emoji)
                                    Text("\(count)")
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                }
                                .padding(8)
                                .background(.ultraThinMaterial.opacity(0.85))
                                .clipShape(Capsule())
                            }
                        }
                        
                        Button(action: { }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .padding(8)
                                .background(.ultraThickMaterial.opacity(0.85))
                                .clipShape(Circle())
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 40)
            }
            
            HStack(spacing: 12) {
                if uiState.isCommentsActive {
                    HStack(spacing: 12) {
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
                        .matchedGeometryEffect(id: "footer-avatar", in: footerAnimation)
                        
                        HStack {
                            TextField("", text: $uiState.commentInput, prompt: Text("Message ...")
                                .foregroundColor(.white))
                            .foregroundColor(.white)
                            
                            
                            Button {
                                withAnimation(.spring()) {
                                    uiState.isCommentsActive.toggle()
                                }
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.accentColor)
                                    .font(.title2)
                            }
                        }
                        .padding(10)
                        .frame(height: 40)
                        .background(.ultraThinMaterial.opacity(0.85))
                        .cornerRadius(20)
                        .matchedGeometryEffect(id: "footer-input", in: footerAnimation)
                    }
                    .padding(.horizontal)
                } else {
                    HStack(spacing: 12) {
                        HStack {
                            if showOptions {
                                switch post.contentType {
                                case .gallery(let medias):
                                    HStack(spacing: 6) {
                                        ForEach(0..<medias.count, id: \.self) { index in
                                            Circle()
                                                .fill(index == uiState.currentPage ? .white : .white.opacity(0.3))
                                                .frame(width: 6, height: 6)
                                        }
                                    }
                                    .animation(.easeInOut(duration: 0.2), value: uiState.currentPage)
                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                    
                                case .media(let mediaType):
                                    if case .video = mediaType, let player = uiState.videoPlayer {
                                        VideoProgressBar(progress: $uiState.videoProgress, player: player)
                                    }
                                    
                                default:
                                    EmptyView()
                                }
                            }
                            Button {
                                if case .media(.photo(_)) = post.contentType {
                                    
                                } else {
                                    withAnimation(.spring()) {
                                        showOptions.toggle()
                                    }
                                }
                                
                            } label: {
                                HStack {
                                    Label {
                                        if !showOptions {
                                            Text("David Guetta & Sia - Beautiful People")
                                                .foregroundStyle(.white)
                                                .font(.subheadline)
                                                .lineLimit(1)
                                        }
                                    } icon: {
                                        Image(systemName: showOptions ? "slider.horizontal.below.square.filled.and.square" : "music.note")
                                            .padding(8)
                                            .foregroundStyle(showOptions ? .white : .accent)
                                            .background(showOptions ? .ultraThinMaterial : .ultraThickMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .matchedGeometryEffect(id: "footer-avatar", in: footerAnimation)
                                    }
                                }
                            }
                        }
                        
                        Button {
                            withAnimation(.spring()) {
                                uiState.isCommentsActive.toggle()
                            }
                        } label: {
                            Label {
                                Text("54")
                            } icon: {
                                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                            }
                            .lineLimit(1)
                            
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .frame(height: 40)
                        .background(.ultraThinMaterial.opacity(0.85))
                        .cornerRadius(16)
                        .matchedGeometryEffect(id: "footer-input", in: footerAnimation)
                    }
                }
                
                Button {
                    // Share logic
                } label: {
                    Image(systemName: "arrowshape.turn.up.right")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .padding(.trailing, 8)
            }
            .padding(.horizontal)
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


//#Preview {
//    PostView(
//        post: PostView.previewPost(
//            type: .media(Factory.randomMediaType(.video))
//        ),
//        index: 0,
//        isActive: .constant(true)
//    )
//}

//#Preview {
//    PostView(
//        post: PostView.previewPost(
//            type: .gallery(Factory.gallery(count: 5))
//        ),
//        index: 0,
//        isActive: .constant(true)
//    )
//}
