//
//  Feed.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 25/03/2025.
//

import Foundation

struct Feed: Identifiable {
    var id = UUID()
    var posts: [Post]
    
    init(posts: [Post]) {
        self.posts = posts
    }
}
