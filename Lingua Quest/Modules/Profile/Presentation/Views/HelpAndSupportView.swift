//
//  HelpAndSupportView.swift
//  Lingua Quest
//
//  Created by taqieallah on 28/07/2026.
//

import SwiftUI

struct HelpAndSupportView: View {
    // MARK: - Properties
    @State var viewModel: HelpAndSupportViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var appearAnimation: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // App Bar
            HStack {
                CustomBackButton(action: { viewModel.onBackTapped() })
                Spacer()
            }
            .overlay(
                Text(L10n.HelpSupport.title)
                    .appTextStyle(.headingLarge, color: .appTextHeading)
            )
            .padding(.horizontal, 20)
            .frame(height: 64)
            .padding(.bottom, 20)
            
            // Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    
                    // Header Image & Bubble
                    VStack(spacing: -12) {
                        Text(L10n.HelpSupport.greeting)
                            .appTextStyle(.bodyMedium, color: .appTextHeading)
                            .padding(.horizontal, 24)
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                            .background(
                                SpeechBubbleShape(cornerRadius: 20, tailSize: 12)
                                    .fill(Color.appSurfaceCard)
                            )
                            .zIndex(1)
                        
                        Image(asset: .helpBird)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .zIndex(0)
                    }
                    .padding(.top, 10)
                    
                    // FAQs Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.HelpSupport.faq)
                            .appTextStyle(.headingMedium, color: .appTextHeading)
                            .padding(.leading, 4)
                        
                        VStack(spacing: 12) {
                            FAQItemView(question: L10n.HelpSupport.FAQ.q1, answer: L10n.HelpSupport.FAQ.a1)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 20)
                            FAQItemView(question: L10n.HelpSupport.FAQ.q2, answer: L10n.HelpSupport.FAQ.a2)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 25)
                            FAQItemView(question: L10n.HelpSupport.FAQ.q3, answer: L10n.HelpSupport.FAQ.a3)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 30)
                            FAQItemView(question: L10n.HelpSupport.FAQ.q4, answer: L10n.HelpSupport.FAQ.a4)
                                .opacity(appearAnimation ? 1 : 0)
                                .offset(y: appearAnimation ? 0 : 35)
                        }
                    }
                    
                    // Still Need Help Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(L10n.HelpSupport.stillNeedHelp)
                            .appTextStyle(.headingMedium, color: .appTextHeading)
                            .padding(.leading, 4)
                        
                        VStack(spacing: 0) {
                            Button(action: { viewModel.onContactUsTapped() }) {
                                LinguaSettingsRow(
                                    icon: .textBubble,
                                    iconBgColor: .appAccentOrange,
                                    title: L10n.HelpSupport.contactUs,
                                    showDivider: true
                                ) {
                                    SettingsRowChevron()
                                }
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { viewModel.onReportBugTapped() }) {
                                LinguaSettingsRow(
                                    icon: .ladybugFill,
                                    iconBgColor: .appAccentRed,
                                    title: L10n.HelpSupport.reportBug,
                                    showDivider: false
                                ) {
                                    SettingsRowChevron()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .background(Color.appSurfaceCard)
                        .cornerRadius(20)
                        .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
                        
                        Text(L10n.HelpSupport.replyTime)
                            .appTextStyle(.body, color: .appTextSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                    }
                    .opacity(appearAnimation ? 1 : 0)
                    .offset(y: appearAnimation ? 0 : 40)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appearAnimation = true
            }
        }
        .appDialog(isPresented: $viewModel.showEmailCopiedDialog) {
            DialogCardContainer(
                showMascot: true,
                mascotImage: .helpBird,
                speechBubbleText: "Copied!"
            ) {
                VStack(spacing: 16) {
                    Text("Email address copied to clipboard.")
                        .dialogSubtitleStyle()
                        .multilineTextAlignment(.center)
                    
                    CustomButton(
                        type: .primary,
                        text: L10n.Common.ok,
                        action: { viewModel.showEmailCopiedDialog = false }
                    )
                    .padding(.top, 8)
                }
            }
        }
    }
}

// MARK: - FAQ Item View
struct FAQItemView: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .appTextStyle(.bodyMedium, color: .appTextHeading)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemIcon: .chevronDown)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.appBorderBrown)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                Text(answer)
                    .appTextStyle(.body, color: .appTextSecondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .transition(.opacity)
            }
        }
        .background(Color.appSurfaceCard)
        .cornerRadius(20)
        .shadow(color: Color.appSemanticSuccess.opacity(0.08), radius: 24, x: 0, y: 8)
    }
}
