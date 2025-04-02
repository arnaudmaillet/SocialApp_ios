//
//  Cluster.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/03/2025.
//

import Foundation

struct Cluster: Hashable, Identifiable {
    let id = UUID()
    let markers: [Marker]
}
