//
//  Post.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/03/2025.
//

import Foundation

struct Post: Identifiable {
    var id: UUID
    var marker: Marker
    var author: User
    var timestamp: Date
    var contentType: PostType
    var text: String?
    
    init(marker: Marker, author: User, timestamp: Date = Date(), contentType: PostType, text: String? = nil) {
        self.id = marker.id
        self.marker = marker
        self.author = author
        self.timestamp = timestamp
        self.contentType = contentType
        self.text = text
    }
}

enum PostType {
    case tweet
    case media(MediaType)
    case gallery([Media])
    case chatRoom(ChatRoom)
}

enum MediaType {
    case photo(Media)
    case video(Media)
    case live(LiveStream)
}

struct Media: Identifiable {
    var id = UUID()
    var url: URL
    var thumbnailURL: URL?
    var type: String // e.g. "image/jpeg", "video/mp4"
}

struct LiveStream {
    var streamURL: URL
    var isLive: Bool
    var viewerCount: Int
}

struct ChatRoom {
    var id: UUID
    var title: String?
    var participants: [User]
    var lastMessage: String?
    var updatedAt: Date
}
