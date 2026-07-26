//
//  FilterChip.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let dotColor: Color?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let dotColor {
                    Circle().fill(dotColor).frame(width: 8, height: 8)
                }
                Text(title)
                    .appTextStyle(.captionBold, color: isSelected ? .white : .appTextHeading)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(Capsule().fill(isSelected ? Color.appBrandPrimary : Color.appSurfaceCard))
            .overlay(
                Capsule().stroke(isSelected ? Color.appBrandPrimary : Color.appBorderLight.opacity(0.5), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    HStack {
        FilterChip(title: "All", dotColor: nil, isSelected: true, action: {})
        FilterChip(title: "Easy", dotColor: .appSemanticSuccess, isSelected: false, action: {})
    }
    .padding()
    .background(Color.appBackgroundWarm)
}
