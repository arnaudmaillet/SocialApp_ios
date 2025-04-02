//
//  DummyMarkers.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/03/2025.
//

import Foundation
import MapKit

var mockMarkers: [UUID: Marker] = Dictionary(uniqueKeysWithValues: (1...30).map { _ in
    let point = Marker(
        coordinate: CLLocationCoordinate2D(
            latitude: 48.8566 + Double.random(in: -0.01...0.01),
            longitude: 2.3522 + Double.random(in: -0.01...0.01)
        ),
        tags: randomWords(count: Int.random(in: 1...3)),
        remaining: CGFloat.random(in: 0...1)
    )
    return (point.id, point)
})
