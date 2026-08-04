//
//  ActivationConfirmDialog.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

enum ActivationState {
    case idle
    case checking
    case loading
    case success
    case failure
}

struct ActivationConfirmDialog: View {
    var viewModel: SettingsViewModel
    var onConfirm: () -> Void
    var onCancel: () -> Void
    var cost: Int = 1500
    
    var body: some View {
        DialogCardContainer(mascotImage: mascotForState) {
            VStack(spacing: 24) {
                switch viewModel.activationState {
                case .idle:
                    idleView
                case .checking, .loading:
                    loadingView
                case .success:
                    successView
                case .failure:
                    failureView
                }
            }
        }
    }
    
    private var mascotForState: Image.Asset {
        switch viewModel.activationState {
        case .idle, .checking, .loading: return .skip
        case .success: return .strongPasswordBird
        case .failure: return .weakPasswordBird 
        }
    }
    
    private var idleView: some View {
        VStack(spacing: 24) {
            // Text
            VStack(spacing: 8) {
                Text(L10n.LockScreenVocabulary.activationTitle)
                    .appTextStyle(.headingMedium, color: .appTextHeading)
                    .multilineTextAlignment(.center)
                
                Text(L10n.LockScreenVocabulary.activationSubtitle)
                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Actions
            VStack(spacing: 12) {
                CustomButton(
                    type: .primary,
                    text: L10n.LockScreenVocabulary.activateAction,
                    action: { onConfirm() },
                    trailing: Image(systemIcon: .dollarsignCircleFill)
                )
                
                CustomButton(
                    type: .secendry,
                    text: L10n.Common.cancel,
                    action: { onCancel() }
                )
            }
        }
    }
    
    private var loadingView: some View {
        BouncingDotsLoadingView(text: L10n.Common.loading)
            .padding(.vertical, 32)
    }
    
    private var successView: some View {
        VStack(spacing: 16) {
            Image(systemIcon: .checkmarkCircleFill)
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.green)
            
            Text(L10n.LockScreenVocabulary.activatedToast)
                .appTextStyle(.headingMedium, color: .appTextHeading)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
    }
    
    private var failureView: some View {
        VStack(spacing: 16) {
            Image(systemIcon: .xmarkCircleFill)
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.red)
            
            Text(L10n.Common.error)
                .appTextStyle(.headingMedium, color: .appTextHeading)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 32)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        // ActivationConfirmDialog(viewModel: viewModel, onConfirm: {}, onCancel: {})
    }
}
