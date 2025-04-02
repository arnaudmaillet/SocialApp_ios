//
//  DummyUsers.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 25/03/2025.
//

import Foundation

let user1 = User(id: UUID(), username: "arnaud", profilePictureURL: URL(string: "https://randomuser.me/api/portraits/men/32.jpg"))
let user2 = User(id: UUID(), username: "julie_dev", profilePictureURL: URL(string: "https://randomuser.me/api/portraits/women/44.jpg"))
let user3 = User(id: UUID(), username: "swift_pro", profilePictureURL: URL(string: "https://randomuser.me/api/portraits/men/99.jpg"))

let users = [user1, user2, user3]
