//
//  ClusterWrapper.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/03/2025.
//

import Foundation


struct ClusterWrapper: Hashable, Identifiable {
    let id = UUID()
    let points: [CustomPointAnnotation]
}
