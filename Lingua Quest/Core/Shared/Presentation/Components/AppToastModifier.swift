//
//  AppToastModifier.swift
//  Lingua Quest
//
//  Created by siam on 23/07/2026.
//

import SwiftUI

enum AppToastType {
    case success
    case info
    case error
    
    var iconName: Image.SystemIcon {
        switch self {
        case .success: return .checkmarkCircleFill
        case .info: return .infoCircleFill
        case .error: return .xmarkCircleFill
        }
    }
    
    var iconColor: Color {
        switch self {
        case .success: return Color.appSemanticSuccess
        case .info: return Color.blue // Replace with app semantic info if exists
        case .error: return Color.red // Replace with app semantic error if exists
        }
    }
}

struct AppToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let type: AppToastType
    let title: String
    let subtitle: String?
    let duration: TimeInterval
    
    @Environment(\.soundPlayer) private var soundPlayer

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 16) {
                        Image(systemIcon: type.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(type.iconColor)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .appTextStyle(.bodyLarge, color: .appTextHeading)
                            
                            if let subtitle = subtitle {
                                Text(subtitle)
                                    .appTextStyle(.bodyMedium, color: .appTextSecondary)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.appSurfaceCard)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        soundPlayer.play(sound: .pop)
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation(.spring()) {
                                isPresented = false
                            }
                        }
                    }
                }
                .zIndex(100)
            }
        }
    }
}

extension View {
    func appToast(isPresented: Binding<Bool>, type: AppToastType, title: String, subtitle: String? = nil, duration: TimeInterval = 3.0) -> some View {
        self.modifier(AppToastModifier(isPresented: isPresented, type: type, title: title, subtitle: subtitle, duration: duration))
    }
}
