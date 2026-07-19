import SwiftUI

struct AchievementsView: View {
    @Environment(Router.self) private var router
    @State private var isAnimating = false
    @State private var selectedTab: Int = 1
    
    //TODO: delete those dummy achievements
    let achievements: [AchievementUIModel] = [
        AchievementUIModel(id: "1", title: "Wild Explorer", subtitle: "Oct 12", uiIcon: .trophyFill, uiIconColor: .appBrandBrown, uiBgColor: .appSurfaceCardWarm),
        AchievementUIModel(id: "2", title: "Hidden Oasis", subtitle: "Nov 05", uiIcon: .starFill, uiIconColor: .appSemanticSuccess, uiBgColor: .appEmptyCircleBg),
        AchievementUIModel(id: "3", title: "Streak Master", subtitle: "Oct 30", uiIcon: .medalFill, uiIconColor: .appBrandPrimary, uiBgColor: .appSurfaceCardWarm),
        AchievementUIModel(id: "4", title: "Word Architect", subtitle: "Nov 12", uiIcon: .pencil, uiIconColor: .appBrandBrown, uiBgColor: .appSurfaceCardMuted),
        AchievementUIModel(id: "5", title: "Speed Learner", subtitle: "Oct 02", uiIcon: .flameFill, uiIconColor: .appSemanticSuccess, uiBgColor: .appEmptyCircleBg),
        AchievementUIModel(id: "6", title: "Global Citizen", subtitle: "Nov 10", uiIcon: .globeAmericasFill, uiIconColor: .appBrandBrown, uiBgColor: .appSurfaceCardWarm)
    ]
    
    var filteredAchievements: [AchievementUIModel] {
        switch selectedTab {
        case 1:
            // Earned
            return achievements.filter { (Int($0.id) ?? 0) <= 3 }
        case 2:
            // Locked
            return achievements.filter { (Int($0.id) ?? 0) > 3 }
        default:
            // All
            return achievements
        }
    }
    
    var body: some View {
        ZStack {
            Color.appBackgroundWarm.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        router.pop()
                    }) {
                        Circle()
                            .fill(Color.appSurfaceCardMuted)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemIcon: .chevronLeft)
                                    .foregroundColor(.appBrandPrimary)
                            )
                    }
                    
                    Spacer()
                    
                    Text(L10n.Achievements.title)
                        .appTextStyle(.headingLarge, color: .appBrandBrown)
                    
                    Spacer()
                    
                    // Invisible view for balancing
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                Divider()
                    .background(Color.appBorderBrown)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Trophies Card
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 100, height: 100)
                                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                                
                                Image(asset: .achivementBird)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                            }
                            
                            VStack(spacing: 8) {
                                Text(L10n.Achievements.myTrophies)
                                    .appTextStyle(.headingLarge, color: .appBrandBrownDark)
                                
                                Text(L10n.Achievements.subtitle)
                                    .appTextStyle(.body, color: .appTextSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(
                                    colors: [Color.appSurfaceCardWarm, Color.white],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.appBorderBrown, lineWidth: 0.5)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.3), value: isAnimating)
                        
                        // Segment Control
                        HStack(spacing: 0) {
                            segmentButton(title: L10n.Achievements.filterAll, index: 0)
                            segmentButton(title: L10n.Achievements.filterEarned, index: 1)
                            segmentButton(title: L10n.Achievements.filterLocked, index: 2)
                        }
                        .frame(height: 44)
                        .background(Color.appSurfaceCardWarm)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.appBorderBrown, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.4), value: isAnimating)
                        
                        // Grid
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(Array(filteredAchievements.enumerated()), id: \.element.id) { index, achievement in
                                AchievementGridItem(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.3), value: isAnimating)
                    }
                }
                
                // Bottom Bar
                VStack(spacing: 16) {
                    Divider().background(Color.appBorderBrown)
                    
                    HStack(spacing: 0) {
                        bottomStatView(value: "8", title: L10n.Achievements.earnedLabel)
                        Divider().frame(height: 30).background(Color.appBorderBrown)
                        bottomStatView(value: "15", title: L10n.Achievements.inProgressLabel, valueColor: .appTealGreen)
                        Divider().frame(height: 30).background(Color.appBorderBrown)
                        bottomStatView(value: "240", title: L10n.Achievements.xpGainedLabel)
                    }
                    .padding(.top, 8)
                    
                    Button(action: {
                        // Claim rewards action
                    }) {
                        HStack {
                            Image(systemIcon: .starCircleFill)
                                .foregroundColor(.white)
                            Text(L10n.Achievements.claimRewards)
                                .appTextStyle(.bodyBold, color: .white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.appBrandPrimary)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                .background(Color.appSurfaceCardWarm)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 0.5).delay(0.8), value: isAnimating)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isAnimating = true
        }
    }
    
    private func segmentButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation {
                selectedTab = index
            }
        }) {
            Text(title)
                .appTextStyle(.bodyBold, color: selectedTab == index ? .white : .appBrandBrownDark)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    selectedTab == index ? Color.appTealGreen : Color.clear
                )
                .clipShape(Capsule())
                .padding(4)
        }
    }
    
    private func bottomStatView(value: String, title: String, valueColor: Color = .appBrandBrownDark) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .appTextStyle(.headingLarge, color: valueColor)
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.appTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AchievementGridItem: View {
    let achievement: AchievementUIModel
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.uiBgColor)
                    .frame(width: 60, height: 60)
                
                Image(systemIcon: achievement.uiIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(achievement.uiIconColor)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .appTextStyle(.bodyBold, color: .appBrandBrownDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                
                Text(achievement.subtitle)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color.appBadgeTealText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.appBadgeTealBg)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appBorderBrown, lineWidth: 0.5)
        )
    }
}

#Preview {
    AchievementsView()
        .environment(Router())
}
