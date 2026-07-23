//
//  GalleryView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 17/07/2026.
//

import SwiftUI

struct GalleryView: View {
    @State var viewModel: GalleryViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView(starCount: 15000000, coinCount: 20000)
            
            // Temporary debug button
            Button(action: {
                viewModel.saveMockItem()
            }) {
                Text("Save Mock Item (Debug)")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
            
            if viewModel.items.isEmpty {
                VStack(spacing: 0) {
                    MyCapturesHeaderView(objectsCollected: viewModel.items.count)
                    EmptyGalleryView()
                }
                .frame(maxHeight: .infinity, alignment: .top)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        MyCapturesHeaderView(objectsCollected: viewModel.items.count)
                        GalleryGridView(items: viewModel.items, onItemTapped: { item in
                            viewModel.onWordTapped(item)
                        })
                    }
                }
            }
        }
        .background(
            HomeBackgroundView()
                .ignoresSafeArea()
        )
        .onAppear {
            viewModel.loadItems()
        }
    }
}

#Preview("LightTheme") {
    GalleryView(viewModel: Resolver.shared.resolve(GalleryViewModel.self))
}

#Preview("DarkTheme") {
    GalleryView(viewModel: Resolver.shared.resolve(GalleryViewModel.self))
        .preferredColorScheme(.dark)
}
