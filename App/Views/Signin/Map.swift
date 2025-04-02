//
//  Map.swift
//  prototype
//
//  Created by Arnaud Maillet on 23/02/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var isVisible = false
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    var animationDelay: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 64)
                .fill(Color.black.opacity(0.2))
                .blur(radius: 10)
                .offset(y: 5)
            
            Map(position: $position, interactionModes: [])
                .mapStyle(.standard())
                .clipShape(RoundedRectangle(cornerRadius: 64))
        }
        .offset(x: isVisible ? -80 : -UIScreen.main.bounds.width)
        .frame(height: UIScreen.main.bounds.height / 3, alignment: .top)
        .opacity(isVisible ? 1 : 0)
        .animation(.spring(dampingFraction: 0.8), value: isVisible)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                isVisible = true
            }
        }
    }
}

#Preview {
    MapView()
}
