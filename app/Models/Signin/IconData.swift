//
//  SigninIcons.swift
//  prototype
//
//  Created by Arnaud Maillet on 23/02/2025.
//

import Foundation
import SwiftUI

struct IconItem: Identifiable {
    let id = UUID()
    let systemName: String
    let backgroundColor: AnyGradient
    let scale: CGFloat
    let offsetX: CGFloat
}

let icons: [IconItem] = [
    IconItem(systemName: "map.circle.fill", backgroundColor: Color.blue.gradient, scale: 1.0, offsetX: 10),
    IconItem(systemName: "person.crop.circle.fill", backgroundColor: Color.yellow.gradient, scale: 0.8, offsetX: 0),
    IconItem(systemName: "mappin.and.ellipse.circle.fill", backgroundColor: Color.indigo.gradient, scale: 0.8, offsetX: 10),
    IconItem(systemName: "message.circle.fill", backgroundColor: Color.green.gradient, scale: 1.0, offsetX: -5),
    IconItem(systemName: "heart.circle.fill", backgroundColor: Color.red.gradient, scale: 0.8, offsetX: 5)
]

