//
//  MapView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 27/02/2025.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let points: [UUID: Point]
    var onMarkerSelected: ((CustomPointAnnotation, CGPoint) -> Void)?
    var onClusterSelected: (([CustomPointAnnotation], CustomPointAnnotation?, CGPoint) -> Void)?

    func makeCoordinator() -> ClusterMapViewCoordinator {
        ClusterMapViewCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(CustomPointAnnotationView.self, forAnnotationViewWithReuseIdentifier: "marker")
        mapView.register(CustomClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: "cluster")
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = .excludingAll
        mapView.mapType = .standard

        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            animated: false
        )

        updateAnnotations(mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(uiView)
    }

    private func updateAnnotations(_ mapView: MKMapView) {
        let existingIDs = Set(
            mapView.annotations.compactMap { ($0 as? CustomPointAnnotation)?.id }
        )
        let newPoints = points.values

        // Si aucun changement d’IDs → ne rien faire
        let newIDs = Set(newPoints.map { $0.id })
        guard newIDs != existingIDs else {
            return
        }

        // Supprimer puis ajouter les nouvelles annotations
        mapView.removeAnnotations(mapView.annotations)

        let annotations = newPoints.map { point -> CustomPointAnnotation in
            let annotation = CustomPointAnnotation(
                coordinate: point.coordinate,
                tags: point.tags,
                remaining: point.remaining
            )
            annotation.id = point.id // Important pour stabilité
            annotation.clusteringIdentifier = "markerCluster"
            return annotation
        }

        mapView.addAnnotations(annotations)
    }
}


//#Preview {
//    MapView(points: points)
//}


