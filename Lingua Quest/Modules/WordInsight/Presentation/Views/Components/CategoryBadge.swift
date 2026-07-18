//
//  CategoryBadge.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Small pill badge showing a word's category, used over images
struct CategoryBadge: View {
    // MARK: - Properties
    let title: String
    
    // MARK: - Body
    var body: some View {
        Text(title.uppercased())
            .appTextStyle(.micro, color: .white)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.appAccentOrange))
    }
}

// MARK: - Preview
#Preview {
    CategoryBadge(title: "Food")
        .padding()
        .background(Color.appBackgroundWarm)
}
