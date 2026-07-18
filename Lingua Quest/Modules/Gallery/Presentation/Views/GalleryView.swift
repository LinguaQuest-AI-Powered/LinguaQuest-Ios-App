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
            
            if items.isEmpty {
                VStack(spacing: 0) {
                    MyCapturesHeaderView(objectsCollected: items.count)
                    EmptyGalleryView()
                }
                .frame(maxHeight: .infinity, alignment: .top)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        MyCapturesHeaderView(objectsCollected: items.count)
                        GalleryGridView(items: items)
                    }
                }
            }
        }
        .background(
            Group {
                if items.isEmpty {
                    Color.appViewBackground
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
