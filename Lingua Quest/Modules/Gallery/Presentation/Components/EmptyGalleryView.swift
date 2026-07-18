//
//  EmptyGalleryView.swift
//  Lingua Quest
//

import SwiftUI

struct EmptyGalleryView: View {
    @State private var isFloating = false
    
    var body: some View {
        VStack(spacing: 0) {
                        HStack {
                Button(action: {
                }) {
                    HStack(spacing: 8) {
                        Image(systemIcon: .photoBadgePlus)
                            .font(.system(size: 14, weight: .bold))
                        Text(L10n.Gallery.addNew)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.appCategorySelectedOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.appEmptyCircleBg)
                    .frame(width: 250, height: 250)
                Image(asset: .emptyGalleryBird)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 380)
                    .offset(y: isFloating ? -8 : 8)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isFloating = true
                }
            }
            .padding(.bottom, 8)
            VStack(spacing: 8) {
                Text(L10n.Gallery.noCapturesYet)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.appEmptyStateTitle)
                Text(L10n.Gallery.noCapturesSubtitle)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.appEmptyStateSubtitle)                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.99, green: 0.97, blue: 0.95).ignoresSafeArea()
        EmptyGalleryView()
    }
}
