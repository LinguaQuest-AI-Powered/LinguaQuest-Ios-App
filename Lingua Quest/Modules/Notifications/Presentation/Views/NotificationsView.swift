//
//  NotificationsView.swift
//  Lingua Quest
//
//  Created by siam on 05/08/2026.
//

import SwiftUI

struct NotificationsView: View {
    @Bindable var viewModel: NotificationsViewModel
    @Environment(Router.self) private var router
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if viewModel.isLoading && viewModel.notifications.isEmpty {
                shimmerSkeleton
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else if viewModel.notifications.isEmpty {
                emptyState
            } else {
                notificationsList
            }
        }
        .background(Color.appBackgroundWarm.ignoresSafeArea())
        .onAppear {
            Task {
                await viewModel.loadInitialData()
            }
        }
        // Custom background for the whole screen
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack {
            CustomBackButton {
                router.pop()
            }
            
            Spacer()
            
            if !viewModel.notifications.isEmpty {
                Button(action: {
                    Task {
                        await viewModel.deleteAll()
                    }
                }) {
                    Text(L10n.Notifications.clearAll)
                        .appTextStyle(.bodyBold, color: .appBrandPrimary)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .background(Color.clear)
        .overlay(
            Text(L10n.Notifications.title)
                .appTextStyle(.headingLarge, color: .appTextHeading)
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.appBorderBrown),
            alignment: .bottom
        )
    }
    
    private var notificationsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.notifications) { notification in
                    NotificationCell(notification: notification)
                        .onTapGesture {
                            Task {
                                await viewModel.markAsRead(notification)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteNotification(notification)
                                }
                            } label: {
                                Label(L10n.Notifications.delete, systemImage: "trash")
                            }
                        }
                        .onAppear {
                            if notification == viewModel.notifications.last {
                                Task {
                                    await viewModel.loadMore()
                                }
                            }
                        }
                }
                
                if viewModel.isLoading && !viewModel.notifications.isEmpty {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .refreshable {
            await viewModel.loadInitialData()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appBrandPrimary.opacity(0.2),
                                Color.appBrandPrimary.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                
                Image(systemIcon: .bell)
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(.appBrandPrimary)
            }
            
            VStack(spacing: 12) {
                Text(L10n.Notifications.emptyTitle)
                    .appTextStyle(.headingMedium, color: .appTextHeading)
                
                Text(L10n.Notifications.emptySubtitle)
                    .appTextStyle(.body, color: .appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var shimmerSkeleton: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(0..<7, id: \.self) { index in
                    NotificationSkeletonCell()
                        // Small staggered animation delay for a premium feel
                        .opacity(1.0 - Double(index) * 0.1)
                        .scaleEffect(0.98 + (0.02 * Double(7 - index) / 7))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

struct NotificationSkeletonCell: View {
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon Placeholder
            Circle()
                .fill(Color.appSurfaceCardMuted.opacity(0.5))
                .frame(width: 48, height: 48)
            
            // Content Placeholder
            VStack(alignment: .leading, spacing: 10) {
                Capsule()
                    .fill(Color.appSurfaceCardMuted.opacity(0.5))
                    .frame(width: 140, height: 16)
                
                VStack(alignment: .leading, spacing: 6) {
                    Capsule()
                        .fill(Color.appSurfaceCardMuted.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                    
                    Capsule()
                        .fill(Color.appSurfaceCardMuted.opacity(0.5))
                        .frame(width: 200, height: 12)
                }
                
                Capsule()
                    .fill(Color.appSurfaceCardMuted.opacity(0.5))
                    .frame(width: 80, height: 10)
                    .padding(.top, 4)
            }
            
            Spacer(minLength: 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.appSurfaceCard)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.appBorderLight.opacity(0.5), lineWidth: 1)
        )
        .shimmer()
    }
}
