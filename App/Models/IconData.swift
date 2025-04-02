//
//  SigninIcons.swift
//  prototype
//
//  Created by Arnaud Maillet on 23/02/2025.
//

import Foundation
import SwiftUI

struct Icon: Identifiable {
    let id = UUID()
    let systemName: String
    let backgroundColor: AnyGradient
    let scale: CGFloat
    let offsetX: CGFloat
}

let icons: [Icon] = [
    Icon(systemName: "map.circle.fill", backgroundColor: Color.blue.gradient, scale: 1.0, offsetX: 10),
    Icon(systemName: "person.crop.circle.fill", backgroundColor: Color.yellow.gradient, scale: 0.8, offsetX: 0),
    Icon(systemName: "mappin.and.ellipse.circle.fill", backgroundColor: Color.indigo.gradient, scale: 0.8, offsetX: 10),
    Icon(systemName: "message.circle.fill", backgroundColor: Color.green.gradient, scale: 1.0, offsetX: -5),
    Icon(systemName: "heart.circle.fill", backgroundColor: Color.red.gradient, scale: 0.8, offsetX: 5)
]

