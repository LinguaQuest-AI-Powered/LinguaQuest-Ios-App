//
//  HomeSectionHeaderView.swift
//  Lingua Quest
//
//  Created by siam on 14/08/2026.
//

import SwiftUI

struct HomeSectionHeaderView: View {
    let title: String
    let actionTitle: String
    var onActionTapped: () -> Void = {}
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTextStyle.displaySmall.font)
                .foregroundColor(Color.appTextHeading)
            
            Spacer()
            
            Button(action: onActionTapped) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .font(AppTextStyle.bodyBold.font)
                    Image(systemIcon: .rightChevron)
                        .font(AppTextStyle.captionMedium.font)
                        .flipsForRightToLeftLayoutDirection(true)
                }
                .foregroundColor(Color.appTextHeading)
            }
        }
    }
}
