//
//  Annotation.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 09/03/2025.
//

import Foundation
import MapKit

class CustomPointAnnotation: NSObject, MKAnnotation, Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var clusteringIdentifier: String?
    var remaining: CGFloat

    init(coordinate: CLLocationCoordinate2D, tags: [String], remaining: CGFloat) {
        self.coordinate = coordinate
        self.title = tags.joined(separator: "\n")
        self.remaining = remaining
        self.clusteringIdentifier = "markerCluster"
    }
}
