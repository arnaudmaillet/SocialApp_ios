//
//  Feed.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 08/03/2025.
//

import SwiftUI

struct FeedConfig {
    var maxDetent: PresentationDetent
    var cornerRadius: CGFloat = 30
    var isInteractiveDimissDisabled: Bool = false
}


extension View {
    @ViewBuilder
    func systemFeedView<Content: View>(
        _ isActive: Binding<Bool>,
        config: FeedConfig = .init(maxDetent: .fraction(0.99)),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.sheet(isPresented: isActive) {
            content()
                .background(.background)
                .clipShape(.rect(cornerRadius: config.cornerRadius))
                .padding([.horizontal, .bottom], 15)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .presentationDetents([config.maxDetent])
                .presentationCornerRadius(0)
                .presentationBackground(.clear)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled(config.isInteractiveDimissDisabled)
        }
    }
}
