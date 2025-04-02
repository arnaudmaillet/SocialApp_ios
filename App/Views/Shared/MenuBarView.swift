//
//  MenuBarView.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 09/03/2025.
//

import SwiftUI

// Vue de la barre de menu.
struct MenuBarView: View {
    let menuItems: [MenuItem]
    @Binding var activeItem: String
    @State private var previousActiveItem: String? = nil

    var body: some View {
        HStack {
            ForEach(menuItems) { item in
                // Utilisation de EquatableView pour ne recalculer la vue qu'en cas de changement effectif.
                EquatableView(content:
                    MenuItemView(
                        item: (icon: item.icon, filledIcon: item.filledIcon, label: item.label, color: item.color),
                        isActive: activeItem == item.icon,
                        shouldAnimate: previousActiveItem != activeItem && activeItem == item.icon
                    )
                )
                .frame(maxWidth: .infinity)
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
    }
}

// Vue représentant un item individuel du menu.
// Conformité à Equatable pour permettre à SwiftUI d'optimiser le rendu.
struct MenuItemView: View, Equatable {
    let item: (icon: String, filledIcon: String, label: String, color: Color)
    let isActive: Bool
    let shouldAnimate: Bool
    
    static func == (lhs: MenuItemView, rhs: MenuItemView) -> Bool {
        return lhs.item.icon == rhs.item.icon &&
               lhs.item.filledIcon == rhs.item.filledIcon &&
               lhs.item.label == rhs.item.label &&
               lhs.isActive == rhs.isActive &&
               lhs.shouldAnimate == rhs.shouldAnimate
    }
    
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
    MenuBarView(
        menuItems: menuItemsData,
        activeItem: .constant("bookmark")
    )
}
