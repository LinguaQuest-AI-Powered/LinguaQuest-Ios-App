//
//  TimeSelectionBottomSheet.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct TimeSelectionBottomSheet: View {
    @Binding var selectedTime: Date
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text(L10n.Settings.selectReminderTime)
                .appTextStyle(.headingMedium, color: .appTextHeading)
                .padding(.top, 16)
            
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.graphical)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "en_US_POSIX")) // Or use app locale
            
            HStack(spacing: 16) {
                Spacer()
                Button(action: onCancel) {
                    Text(L10n.Common.cancel)
                        .appTextStyle(.bodyLarge, color: .appTextSecondary)
                }
                
                Button(action: onSave) {
                    Text("Save") // Add L10n for Save if missing, using hardcoded for now or common
                        .appTextStyle(.bodyLarge, color: .appAccentTeal)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}
