//
//  LinguaCustomToggle.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

struct LinguaCustomToggle: View {
    // MARK: - Properties
    @Binding var isOn: Bool
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .fill(isOn ? Color.appAccentOrange : Color.appBorderBrown)
                .frame(width: 44, height: 24)
            
            Circle()
                .fill(Color.white)
                .frame(width: 16, height: 16)
                .padding(4)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .onTapGesture {
            withAnimation(.spring()) {
                isOn.toggle()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var isOn = true
    return LinguaCustomToggle(isOn: $isOn)
        .padding()
}
