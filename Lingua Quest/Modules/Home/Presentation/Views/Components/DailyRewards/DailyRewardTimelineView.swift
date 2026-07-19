//
//  DailyRewardTimelineView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 18/07/2026.
//

import SwiftUI

/// Horizontal 5-day streak timeline with an animated progress line and
/// staggered node entrance animation
struct DailyRewardTimelineView: View {
    // MARK: - Properties
    let days: [DailyRewardDayUIModel]
    let completedCount: Int
    
    @State private var lineProgress: CGFloat = 0
    @State private var nodesVisible = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            progressLine
                .padding(.top, 23)
                .padding(.horizontal, 16)
            
            HStack(spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.element.id) { index, dayModel in
                    VStack(spacing: 6) {
                        DailyRewardDayNodeView(status: dayModel.status)
                            .scaleEffect(nodesVisible ? 1 : 0)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.12),
                                value: nodesVisible
                            )
                        
                        Text(L10n.Home.dayFormat(dayModel.day))
                            .appTextStyle(.micro, color: dayModel.status == .current ? .appBrandBrown : .appTextSecondary.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear {
            nodesVisible = true
            withAnimation(.easeInOut(duration: 1.2)) {
                lineProgress = 1
            }
        }
    }
    
    // MARK: - Subviews
    private var progressLine: some View {
        GeometryReader { geometry in
            let segmentWidth = geometry.size.width / CGFloat(max(days.count - 1, 1))
            let activeWidth = segmentWidth * CGFloat(completedCount) * lineProgress
            
            ZStack(alignment: .leading) {
                Capsule().fill(Color.appBorderLight.opacity(0.5)).frame(height: 2)
                Capsule().fill(Color.appBrandPrimary).frame(width: activeWidth, height: 3)
            }
        }
        .frame(height: 3)
    }
}

// MARK: - Preview
#Preview {
    DailyRewardTimelineView(
        days: [
            DailyRewardDayUIModel(day: 1, status: .completed),
            DailyRewardDayUIModel(day: 2, status: .completed),
            DailyRewardDayUIModel(day: 3, status: .current),
            DailyRewardDayUIModel(day: 4, status: .locked),
            DailyRewardDayUIModel(day: 5, status: .locked)
        ],
        completedCount: 2
    )
    .padding()
    .background(Color.appBackgroundWarm)
}
