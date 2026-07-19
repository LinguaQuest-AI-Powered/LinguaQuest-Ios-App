import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    private let profileViewModel: ProfileViewModel
    
    init() {
        self.profileViewModel = Resolver.shared.resolve(ProfileViewModel.self)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            GalleryView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Gallery")
                }
                .tag(1)
            
            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(2)
        }
        .tint(Color.appSemanticSuccess)
    }
}
