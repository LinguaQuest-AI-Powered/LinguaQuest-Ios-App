//
//  EmptyGalleryView.swift
//  Lingua Quest
//

import SwiftUI

struct EmptyGalleryView: View {
    @State private var isFloating = false
    var showAddButton: Bool = true
    var title: String? = nil
    var subtitle: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            if showAddButton {
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
                        .background(Color.appAccentOrange)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            
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
