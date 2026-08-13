import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: MainTabItem = .home
    @AppStorage(AppConstants.UserDefaultsKeys.appLanguage) private var appLanguage = "en"
    
    @AppStorage("hasSeenFullAppTutorial") private var hasSeenFullAppTutorial: Bool = false
    @State private var showTutorial: Bool = false
    @State private var currentTutorialStepIndex: Int = 0
    @State private var tutorialBounds: [TutorialStepType: CGRect] = [:]
    
    private var allTutorialSteps: [TutorialStepType] {
        var steps: [TutorialStepType] = []
        if !homeViewModel.dailyRewardViewModel.isClaimed && homeViewModel.dailyRewardViewModel.reward != nil {
            steps.append(.dailyReward)
        }
        steps.append(contentsOf: [
            .learningProgress, .currentLesson, .coins, .xp, .notifications, .exploreWorlds, .switchLanguage,
            .gameCaptures
        ])
        if galleryViewModel.isLockScreenVocabularyEnabled {
            steps.append(.myJournal)
        }
        steps.append(contentsOf: [
            .voicePractice, .roleplay, .mindReader,
            .yourProfile, .profileStats, .settings, .achievements, .leaderboard
        ])
        return steps
    }
    
    @State private var profileViewModel: ProfileViewModel
    @State private var homeViewModel: HomeViewModel
    @State private var galleryViewModel: GalleryViewModel
    @State private var lingosViewModel: LingosViewModel
    
    init() {
        _profileViewModel = State(initialValue: Resolver.shared.resolve(ProfileViewModel.self))
        _homeViewModel = State(initialValue: Resolver.shared.resolve(HomeViewModel.self))
        _galleryViewModel = State(initialValue: Resolver.shared.resolve(GalleryViewModel.self))
        _lingosViewModel = State(initialValue: Resolver.shared.resolve(LingosViewModel.self))
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: homeViewModel)
                    .tag(MainTabItem.home)
                
                GalleryView(viewModel: galleryViewModel)
                    .tag(MainTabItem.gallery)
                
                LingosView(viewModel: lingosViewModel)
                    .tag(MainTabItem.lingos)
                
                ProfileView(viewModel: profileViewModel)
                    .tag(MainTabItem.profile)
            }
            .environment(\.currentTutorialStep, showTutorial && currentTutorialStepIndex < allTutorialSteps.count ? allTutorialSteps[currentTutorialStepIndex] : nil)
            .toolbar(.hidden, for: .tabBar)
            .onPreferenceChange(TutorialBoundsPreferenceKey.self) { bounds in
                self.tutorialBounds = bounds
            }
            
            LinguaQuestTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 22)
                .padding(.bottom, 8)
                
            if showTutorial {
                TutorialOverlayView(
                    bounds: tutorialBounds,
                    steps: allTutorialSteps,
                    isPresented: $showTutorial,
                    currentStepIndex: $currentTutorialStepIndex
                )
            }
        }
        .id(appLanguage)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("VocabularyNotificationTapped"))) { _ in
            selectedTab = .gallery
        }
        .onAppear {
            // Temporary for testing: always show tutorial
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showTutorial = true
            }
        }
        .onChange(of: currentTutorialStepIndex) { _, newIndex in
            guard newIndex < allTutorialSteps.count else { return }
            let step = allTutorialSteps[newIndex]
            switch step {
            case .dailyReward, .learningProgress, .currentLesson, .coins, .xp, .notifications, .exploreWorlds, .switchLanguage:
                if selectedTab != .home { selectedTab = .home }
            case .gameCaptures, .myJournal:
                if selectedTab != .gallery { selectedTab = .gallery }
            case .voicePractice, .roleplay, .mindReader:
                if selectedTab != .lingos { selectedTab = .lingos }
            case .yourProfile, .profileStats, .settings, .achievements, .leaderboard:
                if selectedTab != .profile { selectedTab = .profile }
            }
        }
    }
}

private enum MainTabItem: Int, CaseIterable, Identifiable {
    case home
    case gallery
    case lingos
    case profile
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .home: return L10n.Tabs.home
        case .gallery: return L10n.Tabs.gallery
        case .lingos: return L10n.Tabs.lingos
        case .profile: return L10n.Tabs.profile
        }
    }
    
    var icon: Image.SystemIcon {
        switch self {
        case .home: return .houseFill
        case .gallery: return .photoOnRectangle
        case .lingos: return .starFill
        case .profile: return .personCropCircleFill
        }
    }
}

private struct LinguaQuestTabBar: View {
    @Binding var selectedTab: MainTabItem
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var tabAnimation
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(MainTabItem.allCases) { item in
                Button {
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.74)) {
                        selectedTab = item
                    }
                } label: {
                    tabContent(for: item)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(tabBarBackground)
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.appGlowTeal.opacity(colorScheme == .dark ? 0.36 : 0.42),
                            Color.appBrandPrimary.opacity(colorScheme == .dark ? 0.26 : 0.30)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.28 : 0.12), radius: 18, x: 0, y: 10)
    }
    
    private func tabContent(for item: MainTabItem) -> some View {
        let isSelected = selectedTab == item
        
        return VStack(spacing: 4) {
            Image(systemIcon: item.icon)
                .font(.system(size: 25, weight: .bold))
            
            Text(item.title)
                .appTextStyle(.microSemibold, color: isSelected ? .appAccentTeal : .appTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .foregroundColor(isSelected ? Color.appAccentTeal : Color.appTextSecondary)
        .frame(maxWidth: .infinity)
        .frame(height: 62)
        .background {
            if isSelected {
                Capsule()
                    .fill(Color.appGlowTeal.opacity(colorScheme == .dark ? 0.16 : 0.24))
                    .overlay(
                        Capsule()
                            .fill(Color.appSurfaceCard.opacity(colorScheme == .dark ? 0.34 : 0.40))
                    )
                    .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                    .shadow(color: Color.appGlowTeal.opacity(colorScheme == .dark ? 0.20 : 0.22), radius: 12, x: 0, y: 6)
            }
        }
        .contentShape(Capsule())
    }
    
    private var tabBarBackground: some View {
        Capsule()
            .fill(.ultraThinMaterial)
            .overlay(
                Capsule()
                    .fill(Color.appSurfaceNavBar.opacity(colorScheme == .dark ? 0.74 : 0.78))
            )
    }
}
