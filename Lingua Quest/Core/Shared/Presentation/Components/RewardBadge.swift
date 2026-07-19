//
//  RewardBadge.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//

import SwiftUI

enum RewardBadgeType {
    case coin
    case xp
    case custom(icon: Image.SystemIcon, color: Color)
    
    var icon: Image.SystemIcon {
        switch self {
        case .coin: return .dollarsignCircleFill
        case .xp: return .starCircleFill
        case .custom(let icon, _): return icon
        }
    }
    
    var color: Color {
        switch self {
        case .coin: return .appAccentGold
        case .xp: return .appAccentTeal
        case .custom(_, let color): return color
        }
    }
}

enum RewardBadgeSize {
    case small
    case normal
    case large
}

struct RewardBadge: View {
    let type: RewardBadgeType
    let value: String
    var size: RewardBadgeSize = .normal
    
    var body: some View {
        HStack(spacing: iconSpacing) {
            Image(systemIcon: type.icon)
                .font(iconFont)
                .foregroundColor(type.color)
            
            Text(value)
                .appTextStyle(textFont, color: .appBrandBrown)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(maxWidth: size == .large ? .infinity : nil)
        .background(Color.appSurfaceCard)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.08), radius: shadowRadius, x: 0, y: shadowY)
    }
    
    // MARK: - Styling Helpers
    
    private var iconSpacing: CGFloat {
        switch size {
        case .small: return 4
        case .normal: return 6
        case .large: return 8
        }
    }
    
    private var iconFont: Font {
        switch size {
        case .small: return .system(size: 14, weight: .bold)
        case .normal: return .system(size: 18, weight: .bold)
        case .large: return .system(size: 22, weight: .bold)
        }
    }
    
    private var textFont: AppTextStyle {
        switch size {
        case .small: return .captionBold
        case .normal: return .bodyBold
        case .large: return .bodyLargeBold
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: return 10
        case .normal: return 16
        case .large: return 20
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small: return 6
        case .normal: return 10
        case .large: return 16
        }
    }
    
    private var shadowRadius: CGFloat {
        switch size {
        case .small: return 2
        case .normal: return 4
        case .large: return 6
        }
    }
    
    private var shadowY: CGFloat {
        switch size {
        case .small: return 1
        case .normal: return 2
        case .large: return 3
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        VStack(spacing: 20) {
            RewardBadge(type: .coin, value: "1,250", size: .small)
            RewardBadge(type: .coin, value: "-200", size: .normal)
            RewardBadge(type: .xp, value: "+50 XP", size: .large)
           
        }
    }
}
