//
//  DummyPosts.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 25/03/2025.
//

import Foundation

func generateRandomPost() -> Post {
    let marker = makeMockMarker()
    let author = users.randomElement()!
    
    let types: [PostType] = [
        .tweet,
        .media(.photo(randomMedia())),
        .media(.video(randomVideo())),
        .gallery([randomMedia(), randomMedia(), randomMedia()]),
        .chatRoom(ChatRoom(
            id: UUID(),
            title: "Discussion",
            participants: users.shuffled(),
            lastMessage: "Dernier message dans la room",
            updatedAt: Date()
        ))
    ]
    
    let selectedType = types.randomElement()!
    
    return Post(
        marker: marker,
        author: author,
        contentType: selectedType,
        text: selectedType == .tweet ? "Voici un petit tweet aléatoire ✨" : nil
    )
}

func makeMockMarker() -> Marker {
    return Marker(id: UUID())
}
