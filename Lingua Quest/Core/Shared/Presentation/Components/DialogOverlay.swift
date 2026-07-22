//
//  DialogOverlay.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// A reusable full-screen dimmed backdrop that centers custom dialog content 
struct DialogOverlay<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let dialogContent: () -> DialogContent
    
    func body(content: Content) -> some View {
        content.windowOverlay(isPresented: $isPresented) {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.15))
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
                
                dialogContent()
                    .padding(.horizontal, 24)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.92)))
            .zIndex(10)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented)
        }
    }
}

extension View {
    func appDialog<DialogContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> DialogContent
    ) -> some View {
        modifier(DialogOverlay(isPresented: isPresented, dialogContent: content))
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var isPresented = true
    
    return Color.appBackgroundWarm
        .ignoresSafeArea()
        .appDialog(isPresented: $isPresented) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .frame(height: 200)
        }
}
