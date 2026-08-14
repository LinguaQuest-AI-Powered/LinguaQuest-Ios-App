//
//  MindReaderHeaderView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 31/07/2026.
//

import SwiftUI

struct MindReaderHeaderView: View {
    let action: () -> Void
    let xp: Int
    let coins: Int
    var coinBadgeCenter: Binding<CGPoint>? = nil
    
    var body: some View {
        HStack {
            CustomBackButton(action: action)
            Spacer()
            HStack(spacing: 8) {
                RewardBadge(type: .xp, value: xp.formattedStatsValue(), size: .small)
                RewardBadge(type: .coin, value: coins.formattedStatsValue(), size: .small)
                    .background(GeometryReader { geo in
                        Color.clear.onAppear {
                            if let coinBadgeCenter = coinBadgeCenter {
                                let frame = geo.frame(in: .named("global"))
                                DispatchQueue.main.async {
                                    coinBadgeCenter.wrappedValue = CGPoint(x: frame.midX, y: frame.midY)
                                }
                            }
                        }
                    })
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.appBorderBrown),
            alignment: .bottom
        )
    }
}
