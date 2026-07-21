//
//  EditProfileView.swift
//  LinguaQuest
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var displayName: String = ""
    @State private var tagline: String = ""
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    CustomBackButton {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Text(L10n.EditProfile.title)
                        .appTextStyle(.headingLarge, color: .appBrandBrownDark)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 32) {
                        EditProfileAvatarSection(onChangePhoto: {
                        })
                        .padding(.top, 16)
                        
                        EditProfileFormSection(
                            displayName: $displayName,
                            tagline: $tagline
                        )
                        
                        EditProfileActionsSection(
                            onSave: {
                                dismiss()
                            },
                            onCancel: {
                                dismiss()
                            }
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
    }
}

