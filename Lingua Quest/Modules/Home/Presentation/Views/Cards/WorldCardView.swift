//
//  WorldCardView.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 17/07/2026.
//

import SwiftUI


struct WorldCardView: View {
    let item: WorldItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .topLeading) {
                    Image(asset: item.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 128)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Text(item.difficulty)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.appSemanticSuccess))
                        .padding(8)
                }
                
                if item.isCompleted {
                    Image(systemIcon: .checkmark)
                        .font(AppTextStyle.micro.font)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(Color.appSemanticSuccess))
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -10, y: -10)
                }
            }
            
            Text(item.title)
                .font(AppTextStyle.subtitleMedium.font)
            
            HStack {
                Text(L10n.Home.progress)
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(Color.appTextSecondary)
                
                Spacer()
                
                Text("\(Int(item.progress * 100))%")
                    .font(AppTextStyle.micro.font)
                    .foregroundColor(Color.appProgressBar)
            }
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appBackgroundWarm)
                    .frame(height: 10)
                
                Capsule()
                    .fill(Color.appSemanticSuccess)
                    .frame(width: max(CGFloat(item.progress) * 150, 20), height: 10)
            }
        }
        .padding(12)
        .frame(width: 204)
        .background(Color.appSurfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}


#Preview {
    WorldCardView(
        item: WorldItem(title: L10n.Home.kitchenWorld, imageName: .kitchen, difficulty: L10n.Home.difficultyEasy, progress: 0.4, isCompleted: true)
    )
}
