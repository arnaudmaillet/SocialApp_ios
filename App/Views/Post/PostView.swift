//
//  PostView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 25/03/2025.
//

import SwiftUI
import AVKit

struct PostView: View {
    let post: Post
    let postIndex: Int
    let player: AVPlayer
    
    @State private var text: String = ""
    @State private var isInterfaceHidden: Bool = false
    @State private var isZoomed: Bool = false
    @State private var currentPage: Int? = 0
    @State private var videoPlayer: AVPlayer? = nil
    
    @Binding var isActive: Bool
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        content()
            .onChange(of: isActive) {
                if !isActive {
                    isZoomed = false
                }
                if isActive {
                    isInterfaceHidden = false
                }
            }
    }
    
    @ViewBuilder
    private func imageView(url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
                .scaleEffect(isZoomed ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isZoomed)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isInterfaceHidden.toggle()
                        isZoomed.toggle()
                    }
                }
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
        ZStack {
            // Vérification du type de post
            switch post.contentType {
            case .media(let mediaType):
                mediaFullScreen(mediaType: mediaType)
            case .gallery(let medias):
                galleryFullScreen(medias: medias)
            default:
                // Pour les autres types, on affiche les informations classiques
                VStack(spacing: 16) {
                    Text("Post #\(postIndex + 1)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if let text = post.text {
                        Text(text)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    
                    switch post.contentType {
                    case .gallery(let medias):
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(medias) { media in
                                    AsyncImage(url: media.url) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 200)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    case .chatRoom(let room):
                        VStack {
                            Text(room.title ?? "Salon de discussion")
                                .font(.headline)
                            Text("Participants : \(room.participants.map { $0.username }.joined(separator: ", "))")
                                .font(.subheadline)
                        }
                        .foregroundColor(.white)
                    default:
                        EmptyView()
                    }
                }
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
            }
        }
        .background(.black)
        .ignoresSafeArea()
    }
    
    // Vue pour afficher un média en plein écran
    @ViewBuilder
    private func mediaFullScreen(mediaType: MediaType) -> some View {
        switch mediaType {
        case .photo(let media), .video(let media):
            fullScreenMediaView(url: media.url)
        case .live(let live):
            VStack(spacing: 16) {
                Text("🔴 LIVE")
                    .font(.largeTitle)
                Text("Viewers: \(live.viewerCount)")
                    .font(.title2)
                Link("Voir le live", destination: live.streamURL)
                    .font(.title3)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private func fullScreenMediaView(url: URL) -> some View {
        ZStack {
            if url.absoluteString.contains(".mp4") || url.absoluteString.contains(".mov") {
                VideoPlayerView(player: player, isZoomed: $isZoomed, isInterfaceHidden: $isInterfaceHidden)
            } else {
                imageView(url: url)
            }
            
            mediaInterface()
                .opacity(isInterfaceHidden ? 0.05 : 1)
                .allowsHitTesting(!isInterfaceHidden)
                .animation(.easeInOut(duration: 0.3), value: isInterfaceHidden)
        }
    }
    
    @ViewBuilder
    private func mediaInterface() -> some View {
        VStack {
            // HEADER
            VStack(spacing: 32) {
                HStack(alignment: .top, spacing: 12) {
                    Color.clear.frame(width: 12, height: 1)
                    // Profile icon
                    AsyncImage(url: post.author.profilePictureURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 40)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Username
                        Text(post.author.username)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Title
                        Label {
                            Text("Shenzen, China")
                                .lineLimit(1)
                        } icon: {
                            Image(systemName: "map")
                        }
                        .labelStyle(CustomLabelStyle(spacing: 4))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    HStack() {
                        Label {
                            Text("12,4k")
                                .lineLimit(1)
                        } icon: {
                            Image(systemName: "person")
                        }
                        .labelStyle(CustomLabelStyle(spacing: 4))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        Button(action: {
                            print("Follow pressed !")
                        }) {
                            Text("Follow")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.8))
                                .clipShape(Capsule())
                        }
                    }
                }
                HStack(spacing: 12) {
                    if let text = post.text {
                        Text(text)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)
            .padding(.top, safeAreaInsets.top + 16)
            .padding(.bottom, 16)
            .background(
                LinearGradient(colors: [Color.black.opacity(0.8), Color.clear], startPoint: .top, endPoint: .bottom)
            )
            
            Spacer()
            
            // FOOTER
            VStack(spacing: 16) {
                if case .gallery(let medias) = post.contentType {
                    HStack(spacing: 6) {
                        ForEach(0..<medias.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? .white : .white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.bottom, 4)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
                }
                HStack(alignment: .center, spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 16) {
                            Color.clear.frame(width: 4, height: 1)
                            Button(action: {
                                print("Emoticon '❤️' pressed with count 0!")
                            }) {
                                HStack(spacing: 6) {
                                    Text("❤️")
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.3))
                                .clipShape(Capsule())
                            }
                            ForEach(post.reactions.all.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                Button(action: {
                                    print("Emoticon '\(key)' pressed with count \(value)!")
                                }) {
                                    HStack(spacing: 6) {
                                        Text(key)
                                        Text("\(value)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.3))
                                    .clipShape(Capsule())
                                }
                            }
                            Button(action: {
                                // Action à définir (popup, menu, etc.)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .padding(8)
                                    .background(Color.white.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            Color.clear.frame(width: 4, height: 1)
                        }
                    }
                }
                
                HStack(spacing: 16) {
                    
                    AsyncImage(url: post.author.profilePictureURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 40, height: 40)
                    }
                    
                    // Champ de commentaire
                    TextField("", text: $text, prompt: Text("54 comments ...").foregroundColor(.white.opacity(0.8)))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(20)
                    
                    Button(action: {
                        // Share
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.trailing)
            }
            .padding(.top, 16)
            .padding(.bottom, safeAreaInsets.bottom + 16)
            .background(
                LinearGradient(colors: [Color.black.opacity(0.8), Color.clear], startPoint: .bottom, endPoint: .top)
            )
        }
    }
    
    @ViewBuilder
    private func galleryFullScreen(medias: [Media]) -> some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 0) {
                        ForEach(Array(medias.enumerated()), id: \.offset) { index, media in
                            GeometryReader { geo in
                                AsyncImage(url: media.url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width, height: geo.size.height)
                                        .clipped()
                                        .scaleEffect(isZoomed ? 1.05 : 1.0)
                                        .animation(.easeInOut(duration: 0.3), value: isZoomed)
                                        .onTapGesture {
                                            withAnimation {
                                                isInterfaceHidden.toggle()
                                                isZoomed.toggle()
                                            }
                                        }
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: geo.size.width, height: geo.size.height)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .clipped()
                            .id(index)
                        }
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .global).minX)
                        }
                    )
                    .onPreferenceChange(ScrollOffsetKey.self) { offset in
                        let page = Int((offset + UIScreen.main.bounds.width / 2) / UIScreen.main.bounds.width)
                        currentPage = max(0, min(page, medias.count - 1))
                    }
                }
            }
            .scrollTargetLayout()
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentPage)
            .scrollBounceBehavior(.basedOnSize)
            
            mediaInterface()
                .opacity(isInterfaceHidden ? 0.05 : 1)
                .allowsHitTesting(!isInterfaceHidden)
                .animation(.easeInOut(duration: 0.3), value: isInterfaceHidden)
        }
    }
}

struct FullscreenVideoPlayer: View {
    let url: URL
    @Binding var isZoomed: Bool
    @Binding var isInterfaceHidden: Bool

    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .onAppear {
                    player = AVPlayer(url: url)
                    player?.isMuted = true
                    player?.play()
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player?.currentItem,
                        queue: .main
                    ) { _ in
                        player?.seek(to: .zero)
                        player?.play()
                    }
                }
                .onDisappear {
                    player?.pause()
                    NotificationCenter.default.removeObserver(self)
                }
                .ignoresSafeArea()
                .scaleEffect(isZoomed ? 1.05 : 1.0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isInterfaceHidden.toggle()
                        isZoomed.toggle()
                    }
                }
        }
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//#Preview {
//    PostView(
//        post: PostView.previewPost(
//            type: .media(MediaFactory.randomMediaType(.photo))
//        ),
//        postIndex: 0
//    )
//}



//#Preview {
//    PostView(
//        post: PostView.previewPost(
//            type: .gallery(MediaFactory.gallery(count: 5))
//        ),
//        postIndex: 0,
//        isActive: .constant(true)
//    )
//}

#Preview {
    PostView(
        post: PostView.previewPost(
            type: .media(MediaFactory.randomMediaType(.video))
        ),
        postIndex: 0,
        isActive: .constant(true)
    )
}


enum MediaFactory {
    
    static func randomImage() -> Media {
        Media(
            url: URL(string: "https://picsum.photos/id/\(Int.random(in: 1...100))/800/1200")!,
            thumbnailURL: nil,
            type: "image/jpeg"
        )
    }
    
    static func randomVideo() -> Media {
        Media(
            url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailURL: URL(string: "https://peach.blender.org/wp-content/uploads/title_anouncement.jpg"),
            type: "video/mp4"
        )
    }
    
    static func randomMediaType(_ type: MediaTypeKind = .photo) -> MediaType {
        switch type {
        case .photo:
            return .photo(randomImage())
        case .video:
            return .video(randomVideo())
        case .live:
            return .live(
                LiveStream(
                    streamURL: URL(string: "https://example.com/live")!,
                    isLive: true,
                    viewerCount: Int.random(in: 100...5000)
                )
            )
        }
    }
    
    static func gallery(count: Int = 4) -> [Media] {
        (0..<count).map { _ in randomImage() }
    }
    
    enum MediaTypeKind {
        case photo, video, live
    }
}

extension PostView {
    static func previewPost(type: PostType, text: String? = nil) -> Post {
        let marker = mockMarkers.values.randomElement()!
        let user = mockUsers.randomElement()!
        let emojis = ["💩", "⭐️", "😂", "🔥", "😢"]
        
        var reactions = Reactions()
        for emoji in emojis {
            for _ in 0..<Int.random(in: 0...50) {
                reactions.add(emoji)
            }
        }
        
        let finalText: String? = {
            switch type {
            case .tweet:
                return text ?? randomText(maxWords: 20)
            case .media(let media):
                switch media {
                case .photo:
                    return text ?? "Une belle photo 📸"
                case .video:
                    return text ?? "Regarde cette vidéo 🎥"
                case .live:
                    return text ?? "🔴 En direct"
                }
            case .gallery:
                return text ?? "Une petite galerie 📷"
            case .chatRoom:
                return text
            }
        }()
        
        return Post(
            marker: marker,
            author: user,
            contentType: type,
            text: finalText,
            reactions: reactions
        )
    }
}
