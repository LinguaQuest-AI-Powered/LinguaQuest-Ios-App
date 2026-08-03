

import SwiftUI

struct EditProfileTabBar: View {
    @Binding var selectedTab: EditProfileTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(EditProfileTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(tab.title)
                            .appTextStyle(
                                selectedTab == tab ? .bodyBold : .body,
                                color: selectedTab == tab ? .appTextHeading : .appTextSecondary
                            )
                            .frame(maxWidth: .infinity)

                        // Active indicator
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(
                                selectedTab == tab ? .appBrandPrimary : Color.appBorderBrown.opacity(0.4)
                            )
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appBackgroundWarm.ignoresSafeArea()
        EditProfileTabBar(selectedTab: .constant(.personalInfo))
            .padding()
    }
}
