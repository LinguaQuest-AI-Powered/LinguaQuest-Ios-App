//
//  LinguaSectionHeader.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 17/07/2026.
//

import SwiftUI

struct SectionHeader: View {
    // MARK: - Properties
    let title: String
    let actionTitle: String
    let onActionTapped: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .appTextStyle(.displaySmall, color: .appTextHeading)
            
            Spacer()
            
            Button(action: onActionTapped) {
                HStack(spacing: 4) {
                    Text(actionTitle)
                        .appTextStyle(.bodyBold, color: .appTextHeading)
                    
                    Image(systemIcon: .rightChevron)
                        .font(AppTextStyle.captionMedium.font)
                        .foregroundColor(.appTextHeading)
                        .flipsForRightToLeftLayoutDirection(true)
                }
            }
        }
    }
}

#Preview {
    SectionHeader(
        title: "Achievements",
        actionTitle: "VIEW ALL"
    ) { }
        .padding()
}
