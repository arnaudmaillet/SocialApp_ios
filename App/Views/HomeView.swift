//
//  View.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 24/02/2025.
//

import SwiftUI
import MapKit


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var activeItem: String = "safari"
    @State private var isSheetActive: Bool = false // État pour afficher la sheet

    // Définition des items du menu
    let menuItems: [(icon: String, filledIcon: String, label: String, color: Color)] = [
        ("bookmark", "bookmark.fill", "Saved", .red),
        ("person", "person.fill", "Friends", .blue),
        ("safari", "safari.fill", "Explore", .green),
        ("rectangle.stack", "rectangle.stack.fill", "History", .orange),
        ("magnifyingglass.circle", "magnifyingglass.circle.fill", "Search", .pink)
    ]

    var body: some View {
        print("🔄 HomeView re-rendered")
        return NavigationStack {
            ZStack {
                // La vue de la carte
                ClusterMapView(points: points, selectedPoints: $viewModel.selectedPoints)
                    .edgesIgnoringSafeArea(.all)
                    .onChange(of: viewModel.selectedPoints) {
                        isSheetActive = viewModel.selectedPoints != nil
                    }

                // La barre de menu en bas de l'écran
                VStack {
                    Spacer()
                    MenuBarView(menuItems: menuItems, activeItem: $activeItem)
                }
            }
            .systemFeedView($isSheetActive) {
                // Vous pouvez ajouter ici le contenu de la sheet
            }
            .onChange(of: isSheetActive) {
                viewModel.selectedPoints = nil
            }
        }
    }
}





struct MenuBarView: View {
    let menuItems: [(icon: String, filledIcon: String, label: String, color: Color)]
    @Binding var activeItem: String
    
    @State private var previousActiveItem: String? = nil

    var body: some View {
        HStack {
            ForEach(menuItems, id: \.icon) { item in
                MenuItemView(
                    item: item,
                    isActive: activeItem == item.icon,
                    shouldAnimate: previousActiveItem != activeItem && activeItem == item.icon
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        previousActiveItem = activeItem
                        activeItem = item.icon
                    }
                }
            }
        }
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(.ultraThickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
        .padding(.horizontal, 12)
    }
}

struct MenuItemView: View {
    let item: (icon: String, filledIcon: String, label: String, color: Color)
    let isActive: Bool
    let shouldAnimate: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: isActive ? item.filledIcon : item.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(isActive ? .blue : .gray)
                .contentTransition(shouldAnimate ? .symbolEffect(.replace) : .identity)
            
            Text(item.label)
                .font(.caption2)
                .foregroundColor(isActive ? .blue : .gray)
        }
        .frame(width: 64, height: 64)
        .contentShape(Rectangle())
    }
}



#Preview {
    HomeView()
}
