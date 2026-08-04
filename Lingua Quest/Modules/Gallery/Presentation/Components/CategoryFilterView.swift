//
//  CategoryFilterView.swift
//  Lingua Quest
//

import SwiftUI

struct CategoryFilterView: View {
    let categories: [String]
    let localizedTitles: [String: String]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    FilterChip(
                        title: localizedTitles[category] ?? category,
                        dotColor: dotColor(for: category),
                        isSelected: selectedCategory == category,
                        action: { selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
    
    private func dotColor(for category: String) -> Color? {
        switch category.lowercased() {
        case "easy": return .appSemanticSuccess
        case "medium": return .appAccentOrange
        case "hard": return .appAccentStreakRed
        default: return nil
        }
    }
}

#Preview("LightTheme") {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        CategoryFilterView(
            categories: ["All Items", "KITCHEN", "PARK", "STREET"],
            localizedTitles: ["All Items": "All Items", "KITCHEN": "Kitchen", "PARK": "Park", "STREET": "Street"],
            selectedCategory: .constant("All Items")
        )
    }
}

#Preview("DarkTheme") {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        CategoryFilterView(
            categories: ["All Items", "KITCHEN", "PARK", "STREET"],
            localizedTitles: ["All Items": "All Items", "KITCHEN": "Kitchen", "PARK": "Park", "STREET": "Street"],
            selectedCategory: .constant("All Items")
        )
    }
    .preferredColorScheme(.dark)
}
