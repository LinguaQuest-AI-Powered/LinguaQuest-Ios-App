//
//  CameraCaptureView.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import SwiftUI

struct CameraCaptureView: View {
    @State var viewModel: CameraCaptureViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Camera Feed Background
            CameraPreviewView(session: viewModel.cameraManager.session)
                .ignoresSafeArea()
            
            // UI Overlay
            VStack {
                // Top Bar: Back Button & Find Pill
                HStack(alignment: .top) {
                    CustomBackButton {
                        viewModel.onBackTapped()
                    }
                    
                    Spacer()
                    
                    // Find Pill
                    HStack(spacing: 6) {
                        Image(systemIcon: .magnifyingglass)
                            .foregroundColor(.appAccentOrange)
                            .font(.system(size: 16, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: -2) {
                            Text(L10n.Game.find)
                                .appTextStyle(.body, color: .white)
                            Text(viewModel.targetWord)
                                .appTextStyle(.headingMediumBold, color: .appAccentOrange)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.6))
                    )
                    
                    Spacer()
                    
                    // Right Buttons Stack
                    VStack(spacing: 16) {
                        actionButton(icon: viewModel.cameraManager.isFlashOn ? .boltFill : .boltSlashFill) {
                            viewModel.onFlashTapped()
                        }
                        
                        actionButton(icon: .cameraRotateFill) {
                            viewModel.onFlipCameraTapped()
                        }
                        
                        actionButton(icon: .dollarsignCircleFill) {
                            // Coin / Hint action
                        }
                        
                        actionButton(icon: .lightbulbFill) {
                            // Idea action
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // Bottom Bar: Capture Button
                Button(action: {
                    viewModel.onCaptureTapped()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.appAccentOrange)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                        
                        Image(systemIcon: .cameraFill)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.appAccentOrange)
                    }
                }
                .padding(.bottom, 40)
            }
            
            // Center Dashed Frame
            GeometryReader { geometry in
                let width = geometry.size.width * 0.75
                let height = geometry.size.height * 0.45
                
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.appAccentOrange, style: StrokeStyle(lineWidth: 6, dash: [15, 10]))
                    .frame(width: width, height: height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .allowsHitTesting(false)
        }
        .navigationBarHidden(true)
        .onDisappear {
            viewModel.cameraManager.stopSession()
        }
    }
    
    @ViewBuilder
    private func actionButton(icon: Image.SystemIcon, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemIcon: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.white.opacity(0.9)))
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
