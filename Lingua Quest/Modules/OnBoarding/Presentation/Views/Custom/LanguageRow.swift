//
//  LanguageRow.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 15/07/2026.
//

import SwiftUI

struct LanguageRow: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(language.flag)
                    .font(.system(size: 22))
                    .frame(width: 22, height: 22)
                
                Text(language.name)
                    .appTextStyle(.subtitleMedium, color: .black)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.appSecondary.opacity(0.35) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color.appPrimary : Color.gray.opacity(0.15),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
}

