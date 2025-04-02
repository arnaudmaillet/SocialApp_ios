//
//  MarkerView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 28/02/2025.
//

import UIKit
import MapKit
import SwiftUI

class MarkerView: MKAnnotationView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let containerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        addSubview(containerView)
        containerView.contentView.addSubview(label)
        
        updateContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Met à jour l'affichage avec les tags et ajuste la taille dynamiquement
    func updateContent() {
        guard let annotation = annotation as? Marker else { return }
        
        label.text = annotation.title
        
        let maxWidth: CGFloat = 200
        let paddingX: CGFloat = 6.67
        let paddingY: CGFloat = 3.33
        
        let textWidth = label.intrinsicContentSize.width + (2 * paddingX)
        let textHeight = label.intrinsicContentSize.height + (2 * paddingY)
        
        let width = min(textWidth, maxWidth)
        //let height = max(textHeight, 30)
        let height = textHeight
        
        self.frame = CGRect(x: 0, y: 0, width: width + 50, height: height + 32)
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.frame = CGRect(x: paddingX, y: paddingY, width: width - (2 * paddingX), height: height - (2 * paddingY))
    }

    override var annotation: MKAnnotation? {
        didSet {
            updateContent()
        }
    }
}

/// **Wrapper SwiftUI** pour afficher `CustomPointAnnotationView` dans SwiftUI
//struct CustomPointAnnotationViewWrapper: UIViewRepresentable {
//    let annotation: CustomPointAnnotation
//
//    func makeUIView(context: Context) -> CustomPointAnnotationView {
//        return CustomPointAnnotationView(annotation: annotation, reuseIdentifier: "preview")
//    }
//
//    func updateUIView(_ uiView: CustomPointAnnotationView, context: Context) {}
//}
//
///// **Aperçu SwiftUI**
//#Preview {
//    let annotation = CustomPointAnnotation(
//        coordinate: CLLocationCoordinate2D(
//            latitude: 48.8566 + Double.random(in: -0.01...0.01),
//            longitude: 2.3522 + Double.random(in: -0.01...0.01)
//        ),
//        tags: ["Hello", "World", "Test"],
//        remaining: 0.5
//    )
//
//    ZStack {
//        Color.red.opacity(0.2)
//        CustomPointAnnotationViewWrapper(annotation: annotation)
//    }
//    .frame(maxWidth: .infinity, maxHeight: .infinity)
//}




