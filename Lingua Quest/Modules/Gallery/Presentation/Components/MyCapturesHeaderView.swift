//
//  MyCapturesHeaderView.swift
//  Lingua Quest
//

import SwiftUI

struct MyCapturesHeaderView: View {
    @State private var isBouncing = false
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {

            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.appHeaderTitleDark)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.appHeaderTitleDark.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

#Preview("LightTheme") {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        MyCapturesHeaderView(title: "صور اللعبة", subtitle: "تم جمع ٢٤ أشياء")
    }
}

#Preview("DarkTheme") {
    ZStack {
        Color.cyan.opacity(0.3).ignoresSafeArea()
        MyCapturesHeaderView(title: "صور اللعبة", subtitle: "تم جمع ٢٤ أشياء")
    }
    .preferredColorScheme(.dark)
}
