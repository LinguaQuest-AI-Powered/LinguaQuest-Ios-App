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
    @State private var showDeleteDialog = false
    @State private var notificationToDelete: NotificationEntity?
    
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
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.notifications) { notification in
                    NotificationCell(notification: notification, onDelete: {
                        notificationToDelete = notification
                        showDeleteDialog = true
                    })
                    .onTapGesture {
                        Task {
                            await viewModel.markAsRead(notification)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            notificationToDelete = notification
                            showDeleteDialog = true
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
        .appDialog(isPresented: $showDeleteDialog) {
            DialogCardContainer(mascotImage: .deleteNotifications) {
                VStack(spacing: 24) {
                
                    VStack(spacing: 8) {
                        Text(L10n.Notifications.deleteConfirmTitle)
                            .appTextStyle(.headingMediumBold, color: .appTextHeading)
                            .multilineTextAlignment(.center)
                        
                        Text(L10n.Notifications.deleteConfirmMessage)
                            .appTextStyle(.body, color: .appTextSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    VStack(spacing: 12) {
                        CustomButton(
                            type: .custom(textColor: .white, buttonColor: .appSemanticError),
                            text: L10n.Notifications.delete,
                            action: {
                                if let notification = notificationToDelete {
                                    Task {
                                        await viewModel.deleteNotification(notification)
                                    }
                                }
                                showDeleteDialog = false
                            }
                        )
                        
                        CustomButton(
                            type: .secendry,
                            text: L10n.Common.cancel,
                            action: {
                                showDeleteDialog = false
                            }
                        )
                    }
                }
            }
        }
    }
    
var emptyState: some View {
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
    
var shimmerSkeleton: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(0..<7, id: \.self) { index in
                    NotificationSkeletonCell()
                     
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


