//
//  MindReaderIntroView.swift
//  Lingua Quest
//
//  Created by taqieallah on 31/07/2026.
//

import SwiftUI

struct MindReaderIntroView: View {
    @State var viewModel: MindReaderIntroViewModel
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                MindReaderHeaderView(
                    action: { viewModel.goBack() },
                    xp: viewModel.statsService.xp,
                    coins: viewModel.statsService.coins
                )
                
                Spacer()
                
                // Main Card
                DialogCardContainer(
                    mascotImage: .mindBird,
                    speechBubbleText: L10n.MindReader.lobbyPrompt
                ) {
                    VStack(spacing: 24) {
                        Text(L10n.MindReader.title)
                            .font(AppTextStyle.displayMedium.font)
                            .foregroundColor(.appTextHeading)
                            .multilineTextAlignment(.center)
                        
                        Text(L10n.MindReader.subtitle)
                            .font(AppTextStyle.bodyLarge.font)
                            .foregroundColor(.appTextSecondary)
                            .multilineTextAlignment(.center)
                        
                        // Category Box
                        HStack(spacing: 16) {
                            Text(viewModel.currentCategoryEmoji)
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L10n.MindReader.currentCategory)
                                    .font(AppTextStyle.micro.font)
                                    .foregroundColor(.appTextSecondary)
                                Text(viewModel.currentCategoryName)
                                    .font(AppTextStyle.bodyLargeBold.font)
                                    .foregroundColor(.appTextHeading)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.appAccentOrange.opacity(0.1))
                        .cornerRadius(16)
                        .onTapGesture {
                            viewModel.onChangeCategoryTapped()
                        }
                        
                        VStack(spacing: 16) {
                            CustomButton(
                                type: .primary,
                                text: L10n.MindReader.startGame,
                                action: { viewModel.onStartGameTapped() },
                                trailing: Image(systemIcon: .boltFill)
                            )
                            
                            CustomButton(
                                type: .secendry,
                                text: L10n.MindReader.change,
                                action: { viewModel.onChangeCategoryTapped() }
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .opacity(viewModel.isLoadingGame ? 0 : 1)
            
            if viewModel.isLoadingGame {
                SharedImageLoadingView(
                    imageAsset: .mindLoading,
                    title: L10n.MindReader.loadingTitle,
                    subtitle: L10n.MindReader.loadingSubtitle
                )
            }
        }
        .navigationBarHidden(true)
        .appDialog(isPresented: $viewModel.showReadyDialog) {
            DialogCardContainer(mascotImage: .mindBird) {
                VStack(spacing: 24) {
                    Text(L10n.MindReader.confirmationQuestion)
                        .font(AppTextStyle.headingMedium.font)
                        .foregroundColor(.appTextHeading)
                        .multilineTextAlignment(.center)
                    
                    Text(L10n.MindReader.makeSureFitsWorld(viewModel.currentCategoryName))
                        .font(AppTextStyle.bodyMedium.font)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 16) {
                        CustomButton(
                            type: .secendry,
                            text: L10n.MindReader.notYet,
                            action: { viewModel.onNotYetTapped() }
                        )
                        
                        CustomButton(
                            type: .primary,
                            text: L10n.MindReader.yesLetsGo,
                            action: { viewModel.onYesLetsGoTapped() }
                        )
                    }
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .customBottomSheet(isPresented: $viewModel.showCategorySheet) {
            VStack(spacing: 16) {
                Text(L10n.MindReader.selectCategoryTitle)
                    .appTextStyle(.headingMedium, color: .appTextHeading)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.availableCategories, id: \.id) { category in
                            Button(action: {
                                viewModel.selectCategory(category)
                            }) {
                                HStack(spacing: 16) {
                                    Text(category.emoji)
                                        .font(.system(size: 28))
                                    
                                    Text(L10n.MindReader.categoryName(for: category.key))
                                        .appTextStyle(.bodyLargeBold, color: .appTextHeading)
                                    
                                    Spacer()
                                    
                                    if viewModel.selectedCategory?.id == category.id {
                                        Image(systemIcon: .checkmarkCircleFill)
                                            .foregroundColor(.appAccentTeal)
                                            .font(.system(size: 24))
                                    }
                                }
                                .padding()
                                .background(Color.appBackgroundWarm)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(viewModel.selectedCategory?.id == category.id ? Color.appAccentTeal : Color.appBorderCool, lineWidth: 1.5)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

