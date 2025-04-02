//
//  MediaFactory.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 28/03/2025.
//

import Foundation

enum PostFactory {
    
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
    
    static func randomChatRoom() -> ChatRoom {
        let participants = Array(mockUsers.shuffled().prefix(2))
        return ChatRoom(
            id: UUID(),
            title: "Discussion entre amis",
            participants: participants,
            lastMessage: "À bientôt 👋",
            updatedAt: Date()
        )
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

        let comments: [Comment] = {
            if case .chatRoom(let room) = type {
                return [
                    Comment(author: room.participants[0], text: "Salut 👋"),
                    Comment(author: room.participants[1], text: "Hey ! Ça va ?"),
                    Comment(author: room.participants[0], text: "Oui super, et toi ? 😄")
                ]
            } else {
                return []
            }
        }()

        return Post(
            marker: marker,
            author: user,
            contentType: type,
            text: finalText,
            comments: comments,
            reactions: reactions
        )
    }
}
