//
//  GalleryGridView.swift
//  Lingua Quest
//

import SwiftUI

struct GalleryGridView: View {
    @State private var selectedCategory: String = "All Items"
    let allCategories = ["All Items", "KITCHEN", "PARK", "STREET"]
    let localizedTitles: [String: String] = [
        "All Items": L10n.Gallery.Categories.allItems,
        "KITCHEN": L10n.Gallery.Categories.kitchen,
        "PARK": L10n.Gallery.Categories.park,
        "STREET": L10n.Gallery.Categories.street
    ]
    
    var items: [CapturedItem]
    var onItemTapped: (CapturedItem) -> Void
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var filteredItems: [CapturedItem] {
        if selectedCategory == "All Items" {
            return items
        } else {
            return items.filter { $0.category.uppercased() == selectedCategory.uppercased() }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CategoryFilterView(categories: allCategories, localizedTitles: localizedTitles, selectedCategory: $selectedCategory)
                .padding(.bottom, 10)
            
            if filteredItems.isEmpty {
                EmptyGalleryView(
                 
                    title: L10n.Gallery.emptyFilterItemsTitle,
                    subtitle: L10n.Gallery.emptyFilterItemsSubtitle
                )
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredItems) { item in
                            Button(action: {
                                onItemTapped(item)
                            }) {
                                CaptureCardView(item: item)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: selectedCategory)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        GalleryGridView(items: CapturedItem.mocks, onItemTapped: { _ in })
    }
}
