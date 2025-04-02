//
//  InterfaceOverlay.swift
//  SocialApp
//
//  Created by Arnaud Maillet on 28/03/2025.
//

import SwiftUI

struct Overlay: View {
    let post: Post
    @Bindable var uiState: PostUIState
    @Environment(\.safeAreaInsets) private var insets
    @State private var headerSize: CGSize = .zero
    @State private var footerSize: CGSize = .zero
    
    var body: some View {
        VStack {
            HeaderView(post: post)
                .padding(.top, insets.top + 16)
                .padding(.bottom, 16)
                .padding(.horizontal)
                .background(
                    uiState.isOverlayBlurred || uiState.isCommentsActive ?
                    AnyShapeStyle(.ultraThinMaterial) :
                        AnyShapeStyle(LinearGradient(colors: [Color.black.opacity(0.8), Color.clear], startPoint: .top, endPoint: .bottom))
                )
                .measureViewSize($headerSize)
                .onChange(of: headerSize.height) {
                    uiState.headerSize.height = headerSize.height
                }
            
//            if case .chatRoom = post.contentType {
//                // Ne rien afficher pour le chat
//            } else {
//                HStack {
//                    VStack(alignment: .leading) {
//                        if let text = post.text {
//                            Text("\(text)")
//                                .font(.subheadline)
//                                .foregroundColor(.white.opacity(0.8))
//                                .lineLimit(2)
//                            
//                        }
//                        HStack {
//                            Label("Shenzhen, China", systemImage: "map")
//                                .font(.caption)
//                                .foregroundStyle(.white.opacity(0.8))
//                                .lineLimit(1)
//                                .padding(.top, 2)
//                            Label("2m", systemImage: "clock")
//                                .font(.caption2)
//                                .foregroundStyle(.white.opacity(0.8))
//                                .lineLimit(1)
//                                .padding(.top, 2)
//                        }
//                    }
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 6)
//                    .background(.black.opacity(0.4))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    Spacer()
//                }
//                .padding(.horizontal)
//            }
            
            Spacer()
            
            FooterView(post: post, uiState: uiState)
                .padding(.bottom, insets.bottom + 16)
                .padding(.top, 16)
                .background(
                    uiState.isOverlayBlurred || uiState.isCommentsActive ?
                    AnyShapeStyle(.ultraThinMaterial) :
                        AnyShapeStyle(LinearGradient(colors: [Color.black.opacity(0.8), Color.clear], startPoint: .bottom, endPoint: .top))
                )
                .measureViewSize($footerSize)
                .onChange(of: footerSize.height) {
                    uiState.footerSize.height = footerSize.height
                }
        }
        .ignoresSafeArea()
    }
}
