//
//  CustomBackButton.swift
//  Lingua Quest
//
//  Created by siam on 16/07/2026.
//

import SwiftUI
struct CustomBackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemIcon: .chevronLeft)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.appBrandPrimary)
                .frame(width: 38, height: 38)
              
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    
    }
}

#Preview {
    CustomBackButton(action: { print("Back tapped") })
        .padding()
}

