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
    
    // MARK: - Body
    var body: some View {
        HStack {
            Text(title)
                .appTextStyle(.sectionTitle, color: .appProfileTextSectionTitle)
            
            Spacer()
            
            Button(action: onActionTapped) {
                Text(actionTitle)
                    .appTextStyle(.linkText, color: .appProfileLinkBrown)
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
