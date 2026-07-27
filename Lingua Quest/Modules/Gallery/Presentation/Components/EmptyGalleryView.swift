//
//  EmptyGalleryView.swift
//  Lingua Quest
//

import SwiftUI

struct EmptyGalleryView: View {
    @State private var isFloating = false
    var title: String? = nil
    var subtitle: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)
            
            ZStack {
                Circle()
                    .fill(Color.appEmptyCircleBg)
                    .frame(width: 200, height: 200)
                Image(asset: .emptyGallary)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .offset(y: isFloating ? -8 : 8)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isFloating = true
                }
            }
            .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                Text(title ?? L10n.Gallery.noCapturesYet)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.appEmptyStateTitle)
                Text(subtitle ?? L10n.Gallery.noCapturesSubtitle)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.appEmptyStateSubtitle)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer(minLength: 120)
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.99, green: 0.97, blue: 0.95).ignoresSafeArea()
        EmptyGalleryView()
    }
}
