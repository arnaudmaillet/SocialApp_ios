//
//  Title.swift
//  prototype
//
//  Created by Arnaud Maillet on 24/02/2025.
//

import SwiftUI

struct TitleView: View {
    
    var animationDelay: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                TextView(text: "The Map")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                TextView(text: "where you can post", animationDelay: 0.2)
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            TextView(text: "Anything. Anywhere. Anytime.", animationDelay: 0.3)
            .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
    }
}

#Preview {
    TitleView()
}
