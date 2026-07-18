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
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(localizedTitles[category] ?? category)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(selectedCategory == category ? Color.appTextSelectedBrown : Color.appTextUnselectedBrown)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selectedCategory == category ? Color.appCategorySelectedOrange : Color.appCategoryUnselectedBg)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
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
