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
                Image(language.flag)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text(language.name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color("AppSecondaryColor").opacity(0.35) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color("AppPrimaryColor") : Color.gray.opacity(0.15),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
    }
}

