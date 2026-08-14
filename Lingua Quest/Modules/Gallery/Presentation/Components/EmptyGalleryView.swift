//
//  EmptyGalleryView.swift
//  Lingua Quest
//

import SwiftUI

struct EmptyGalleryView: View {
    @State private var isFloating = false
    var title: String? = nil
    var subtitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            DialogCardContainer(
                showMascot: true,
                mascotImage: .emptyGallary,
                customMascotSize: CGSize(width: 140, height: 140),
                customTopSpacing: 70,
                speechBubbleText: nil
            ) {
                VStack(spacing: 12) {
                    Text(title ?? L10n.Gallery.noCapturesYet)
                        .dialogTitleStyle()
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle ?? L10n.Gallery.noCapturesSubtitle)
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    
                    CustomButton(
                        type: .primary,
                        text: L10n.Gallery.goToHome
                    ) {
                        action?()
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal, 24)
            .offset(y: -40)
            
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
