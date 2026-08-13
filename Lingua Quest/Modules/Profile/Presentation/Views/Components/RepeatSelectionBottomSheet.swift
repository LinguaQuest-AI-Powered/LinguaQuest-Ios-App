//
//  RepeatSelectionBottomSheet.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

struct RepeatSelectionBottomSheet: View {
    @Binding var repeatDays: [Int]
    let onSave: () -> Void
    
    @State private var localRepeatDays: Set<Int>
    @State private var selectionMode: RepeatMode
    
    enum RepeatMode {
        case everyday, weekdays, weekends, custom
    }
    
    init(repeatDays: Binding<[Int]>, onSave: @escaping () -> Void) {
        self._repeatDays = repeatDays
        self.onSave = onSave
        
        let days = Set(repeatDays.wrappedValue)
        self._localRepeatDays = State(initialValue: days)
        
        if days == Set([1,2,3,4,5,6,7]) {
            self._selectionMode = State(initialValue: .everyday)
        } else if days == Set([2,3,4,5,6]) {
            self._selectionMode = State(initialValue: .weekdays)
        } else if days == Set([1,7]) {
            self._selectionMode = State(initialValue: .weekends)
        } else {
            self._selectionMode = State(initialValue: .custom)
        }
    }
    
    let allDaysText = ["S", "M", "T", "W", "T", "F", "S"]
    let allDaysValues = [1, 2, 3, 4, 5, 6, 7]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(L10n.Settings.repeatFrequency)
                .appTextStyle(.headingMedium, color: .appTextHeading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
            
            repeatOptionRow(title: L10n.Settings.repeatEveryDay, mode: .everyday, targetDays: [1,2,3,4,5,6,7])
            repeatOptionRow(title: L10n.Settings.repeatWeekdays, mode: .weekdays, targetDays: [2,3,4,5,6])
            repeatOptionRow(title: L10n.Settings.repeatWeekends, mode: .weekends, targetDays: [1,7])
            repeatOptionRow(title: L10n.Settings.repeatCustom, mode: .custom, targetDays: [])
            
            if selectionMode == .custom {
                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { index in
                        let dayVal = allDaysValues[index]
                        let isSelected = localRepeatDays.contains(dayVal)
                        
                        Text(allDaysText[index])
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(isSelected ? .white : .appTextSecondary)
                            .frame(width: 40, height: 40)
                            .background(isSelected ? Color.appAccentTeal : Color.appSurfaceCard)
                            .clipShape(Circle())
                            .onTapGesture {
                                if isSelected {
                                    localRepeatDays.remove(dayVal)
                                } else {
                                    localRepeatDays.insert(dayVal)
                                }
                            }
                    }
                }
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
            CustomButton(
                type: .primary,
                text: "Save",
                action: {
                    repeatDays = Array(localRepeatDays).sorted()
                    onSave()
                }
            )
            .padding(.top, 24)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
    
    private func repeatOptionRow(title: String, mode: RepeatMode, targetDays: [Int]) -> some View {
        Text(title)
            .appTextStyle(.bodyLarge, color: selectionMode == mode ? .appAccentTeal : .appTextHeading)
            .onTapGesture {
                selectionMode = mode
                if mode != .custom {
                    localRepeatDays = Set(targetDays)
                }
            }
    }
}
