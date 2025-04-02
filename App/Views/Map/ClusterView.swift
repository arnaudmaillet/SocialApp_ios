//
//  ClusterAnnotation.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 27/02/2025.
//

import MapKit
import UIKit
import SwiftUI

class CustomClusterAnnotationView: MKAnnotationView {
    
    var firstAnnotationView: CustomPointAnnotationView?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.superview?.bringSubviewToFront(self)
        updateView()
    }
    
    private func updateView() {
        guard let cluster = annotation as? MKClusterAnnotation,
              let firstAnnotation = cluster.memberAnnotations.first as? Marker else { return }

        if firstAnnotationView == nil {
            firstAnnotationView = CustomPointAnnotationView(annotation: firstAnnotation, reuseIdentifier: "markerPreview")
            addSubview(firstAnnotationView!)
        }

        firstAnnotationView?.annotation = firstAnnotation
        firstAnnotationView?.updateContent()

        // Adapter la taille du cluster à la taille de la première annotation
        let size = firstAnnotationView?.frame.size ?? CGSize(width: 40, height: 40)
        self.frame = CGRect(origin: self.frame.origin, size: size)
        firstAnnotationView?.frame = CGRect(origin: .zero, size: size)
    }
}


struct CustomClusterAnnotationViewWrapper: UIViewRepresentable {
    let clusterAnnotation: MKClusterAnnotation

    func makeUIView(context: Context) -> CustomClusterAnnotationView {
        return CustomClusterAnnotationView(annotation: clusterAnnotation, reuseIdentifier: "clusterPreview")
    }

    func updateUIView(_ uiView: CustomClusterAnnotationView, context: Context) {}
}

//#Preview {
//    let annotations = [
//        CustomPointAnnotation(
//            coordinate: CLLocationCoordinate2D(
//                latitude: 48.8566 + Double.random(in: -0.005...0.005),
//                longitude: 2.3522 + Double.random(in: -0.005...0.005)
//            ),
//            tags: ["Tag1", "Tag2"],
//            remaining: 0.7
//        ),
//        CustomPointAnnotation(
//            coordinate: CLLocationCoordinate2D(
//                latitude: 48.8566 + Double.random(in: -0.005...0.005),
//                longitude: 2.3522 + Double.random(in: -0.005...0.005)
//            ),
//            tags: ["Tag3", "Tag4"],
//            remaining: 1.2
//        )
//    ]
//    
//    let clusterAnnotation = MKClusterAnnotation(memberAnnotations: annotations)
//    
//    ZStack {
//        Color.blue.opacity(0.2)
//        CustomClusterAnnotationViewWrapper(clusterAnnotation: clusterAnnotation)
//    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//}
