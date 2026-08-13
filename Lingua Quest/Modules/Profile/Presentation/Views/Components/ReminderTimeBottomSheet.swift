//
//  ReminderTimeBottomSheet.swift
//  Lingua Quest
//
//  Created by taqieallah on 13/08/2026.
//

import SwiftUI

struct ReminderTimeBottomSheet: View {
    @Binding var reminderTime: Date
    let onSave: () -> Void
    
    @State private var localReminderTime: Date
    
    init(reminderTime: Binding<Date>, onSave: @escaping () -> Void) {
        self._reminderTime = reminderTime
        self.onSave = onSave
        self._localReminderTime = State(initialValue: reminderTime.wrappedValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(L10n.Settings.reminderTime)
                .appTextStyle(.headingMedium, color: .appTextHeading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
            
            DatePicker("", selection: $localReminderTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "en_US_POSIX"))
                .frame(maxWidth: .infinity, alignment: .center)
            
            CustomButton(
                type: .primary,
                text: "Save",
                action: {
                    reminderTime = localReminderTime
                    onSave()
                }
            )
            .padding(.top, 24)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
}
