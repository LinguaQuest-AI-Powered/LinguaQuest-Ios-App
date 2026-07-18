//
//  GalleryView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 17/07/2026.
//

import SwiftUI

struct GalleryView: View {
    
    var items: [CapturedItem] = CapturedItem.mocks

    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView(starCount: 15000000, coinCount: 20000)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    MyCapturesHeaderView(objectsCollected: items.count)
                
                if items.isEmpty {
                    GeometryReader { geometry in
                        EmptyGalleryView()
                            .frame(minHeight: geometry.size.height - 200)
                    }
                } else {
                    GalleryGridView(items: items)
                }
                }
            }
        }
        .background(
            Group {
                if items.isEmpty {
                    Color(red: 0.99, green: 0.97, blue: 0.95)
                        .ignoresSafeArea()
                } else {
                    Image(asset: .appBackground)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
            }
        )
    }
}

#Preview {

    GalleryView()

}
