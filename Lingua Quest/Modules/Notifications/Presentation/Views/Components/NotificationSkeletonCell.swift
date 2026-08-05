//
//  NotificationSkeletonCell.swift
//  Lingua Quest
//
//  Created by siam on 05/08/2026.
//


import SwiftUI

struct NotificationSkeletonCell: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon Placeholder
            Circle()
                .fill(Color.appSurfaceCardMuted.opacity(0.5))
                .frame(width: 48, height: 48)
            
            // Content Placeholder
            VStack(alignment: .leading, spacing: 10) {
                Capsule()
                    .fill(Color.appSurfaceCardMuted.opacity(0.5))
                    .frame(width: 140, height: 16)
                
                VStack(alignment: .leading, spacing: 6) {
                    Capsule()
                        .fill(Color.appSurfaceCardMuted.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(Color.appSurfaceCardMuted.opacity(0.5))
                        .frame(width: 200, height: 12)
                }
                
                Capsule()
                    .fill(Color.appSurfaceCardMuted.opacity(0.5))
                    .frame(width: 80, height: 10)
                    .padding(.top, 4)
            }
            
            Spacer(minLength: 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.appSurfaceCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.appBorderLight.opacity(0.5), lineWidth: 1)
        )
        .shimmer()
    }
}