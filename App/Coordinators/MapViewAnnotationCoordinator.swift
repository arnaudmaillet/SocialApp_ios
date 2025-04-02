//
//  MapViewAnnotationCoordinator.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 27/02/2025.
//

import Foundation
import MapKit


class MapViewAnnotationCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    private var annotationsCache: [String: Marker] = [:]
    private var currentAnnotationIDs: Set<UUID> = []
    
    // Adjusting position before rendering
    private let offsetPosition: (x: CGFloat, y: CGFloat) = (x: -75, y: -128)
    
    init(parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let cluster = annotation as? MKClusterAnnotation {
            let clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: "cluster") as? ClusterView ?? ClusterView(annotation: cluster, reuseIdentifier: "cluster")
            clusterView.annotation = cluster
            return clusterView
        } else if let customAnnotation = annotation as? Marker {
            let markerView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MarkerView ?? MarkerView(annotation: customAnnotation, reuseIdentifier: "marker")
            markerView.annotation = customAnnotation
            markerView.clusteringIdentifier = "markerCluster"
            
            if annotationsCache[customAnnotation.coordinate.uniqueKey] == nil {
                annotationsCache[customAnnotation.coordinate.uniqueKey] = customAnnotation
            }
            return markerView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let marker = view.annotation as? Marker {
            let screenPoint = mapView.convert(marker.coordinate, toPointTo: mapView)
            parent.onMarkerActive?(
                marker,
                CGPoint(x: screenPoint.x + offsetPosition.x, y: screenPoint.y + offsetPosition.y)
            )
        } else if let clusterAnnotation = view.annotation as? MKClusterAnnotation,
                  let clusterView = view as? ClusterView,
                  let firstAnnotation = clusterView.firstAnnotationView?.annotation as? Marker {
            
            let containedMarkers = clusterAnnotation.memberAnnotations.compactMap { $0 as? Marker }
            let screenPoint = mapView.convert(clusterAnnotation.coordinate, toPointTo: mapView)

            parent.onClusterActive?(
                containedMarkers,
                firstAnnotation,
                CGPoint(x: screenPoint.x + offsetPosition.x, y: screenPoint.y + offsetPosition.y)
            )
        }
        
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
