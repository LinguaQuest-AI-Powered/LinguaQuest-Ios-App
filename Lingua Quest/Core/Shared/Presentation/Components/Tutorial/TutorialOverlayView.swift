//
//  TutorialOverlayView.swift
//  Lingua Quest
//
//  Created by siam on 13/08/2026.
//

import SwiftUI

struct TutorialOverlayView: View {
    let bounds: [TutorialStepType: CGRect]
    let steps: [TutorialStepType]
    @Binding var isPresented: Bool
    
    @State private var currentStepIndex: Int = 0
    @State private var highlightedFrame: CGRect = .zero
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                // Dimmed background with cutout
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .mask(
                        ZStack {
                            Rectangle()
                            if highlightedFrame != .zero {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .frame(width: highlightedFrame.width + 16, height: highlightedFrame.height + 16)
                                    .position(x: highlightedFrame.midX, y: highlightedFrame.midY)
                                    .blendMode(.destinationOut)
                            }
                        }
                    )
                    .animation(.easeInOut(duration: 0.3), value: highlightedFrame)
                    .onTapGesture {
                        // Prevent accidental taps from passing through to underneath UI
                    }
                
                if highlightedFrame != .zero {
                    TutorialTooltipCard(
                        step: steps[currentStepIndex],
                        currentStepIndex: currentStepIndex,
                        totalSteps: steps.count,
                        onNext: {
                            if currentStepIndex < steps.count - 1 {
                                withAnimation {
                                    currentStepIndex += 1
                                }
                            } else {
                                dismiss()
                            }
                        },
                        onSkip: dismiss
                    )
                    .position(tooltipPosition(for: highlightedFrame, in: proxy.size))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: highlightedFrame)
                    .animation(.easeInOut, value: currentStepIndex)
                }
            }
            .onAppear {
                updateHighlightedFrame()
            }
            .onChange(of: currentStepIndex) { _, _ in
                updateHighlightedFrame()
            }
            .onChange(of: bounds) { _, _ in
                updateHighlightedFrame()
            }
        }
        .zIndex(999) // Ensure it stays on top
    }
    
    private func updateHighlightedFrame() {
        guard currentStepIndex < steps.count else { return }
        let currentStep = steps[currentStepIndex]
        if let frame = bounds[currentStep] {
            withAnimation(.easeInOut(duration: 0.3)) {
                highlightedFrame = frame
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
    
    private func tooltipPosition(for targetFrame: CGRect, in containerSize: CGSize) -> CGPoint {
        // Calculate the ideal position for the tooltip card
        // We assume the card is roughly 250px tall and spans most of the width
        let cardHeight: CGFloat = 250
        let spacing: CGFloat = 20
        
        let targetMidX = containerSize.width / 2
        
        if targetFrame.maxY + spacing + cardHeight <= containerSize.height {
            // Place below
            return CGPoint(x: targetMidX, y: targetFrame.maxY + spacing + (cardHeight / 2))
        } else if targetFrame.minY - spacing - cardHeight >= 0 {
            // Place above
            return CGPoint(x: targetMidX, y: targetFrame.minY - spacing - (cardHeight / 2))
        } else {
            // Center in screen if neither fits perfectly
            return CGPoint(x: targetMidX, y: containerSize.height / 2)
        }
    }
}
