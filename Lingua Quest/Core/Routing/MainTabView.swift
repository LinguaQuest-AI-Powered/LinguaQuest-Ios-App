import SwiftUI

struct MainTabView: View {
    @SceneStorage("MainTabView.selectedTab") private var selectedTabRawValue: Int = MainTabItem.home.rawValue
    
    private var selectedTab: Binding<MainTabItem> {
        Binding(
            get: { MainTabItem(rawValue: selectedTabRawValue) ?? .home },
            set: { selectedTabRawValue = $0.rawValue }
        )
    }
    
    private let profileViewModel: ProfileViewModel
    private let homeViewModel: HomeViewModel
    
    init() {
        self.profileViewModel = Resolver.shared.resolve(ProfileViewModel.self)
        self.homeViewModel = Resolver.shared.resolve(HomeViewModel.self)
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: selectedTab) {
                HomeView(viewModel: homeViewModel)
                    .tag(MainTabItem.home)
                
                GalleryView()
                    .tag(MainTabItem.gallery)
                
                ProfileView(viewModel: profileViewModel)
                    .tag(MainTabItem.profile)
            }
            .toolbar(.hidden, for: .tabBar)
            
            LinguaQuestTabBar(selectedTab: selectedTab)
                .padding(.horizontal, 22)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

private enum MainTabItem: Int, CaseIterable, Identifiable {
    case home
    case gallery
    case profile
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .home: return L10n.Tabs.home
        case .gallery: return L10n.Tabs.gallery
        case .profile: return L10n.Tabs.profile
        }
    }
    
    var icon: Image.SystemIcon {
        switch self {
        case .home: return .houseFill
        case .gallery: return .photoOnRectangle
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
