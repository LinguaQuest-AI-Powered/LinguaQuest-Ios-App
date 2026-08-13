//
//  GalleryView.swift
//  Lingua Quest
//
//  Created by Al3dwy on 17/07/2026.
//

import SwiftUI

struct GalleryView: View {
    @State var viewModel: GalleryViewModel
    @State private var selectedTab: Int = 0
    @Namespace private var tabNamespace
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("hasSeenGalleryTutorial") private var hasSeenGalleryTutorial: Bool = false
    @State private var showTutorial: Bool = false
    @State private var tutorialBounds: [TutorialStepType: CGRect] = [:]
    
    private var tutorialSteps: [TutorialStepType] {
        viewModel.isLockScreenVocabularyEnabled ? [.gameCaptures, .myJournal] : [.gameCaptures]
    }
    
    // For Word Filters
    let wordCategories = ["All", "easy", "medium", "hard"]
    let wordLocalizedTitles = [
        "All": L10n.Gallery.filterAll,
        "easy": L10n.Home.difficultyEasy,
        "medium": L10n.Home.difficultyMedium,
        "hard": L10n.Home.difficultyHard
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                AppHeaderView(
                    starCount: viewModel.statsService.xp,
                    coinCount: viewModel.statsService.coins
                )
            

            if viewModel.isLockScreenVocabularyEnabled {
                HStack(spacing: 0) {
                    Button(action: { withAnimation { selectedTab = 0 } }) {
                        VStack(spacing: 6) {
                            Text(L10n.Gallery.capturesTab)
                                .font(.system(size: 18, weight: selectedTab == 0 ? .bold : .medium, design: .rounded))
                                .foregroundColor(selectedTab == 0 ? .appAccentOrange : .appTextSecondary.opacity(0.6))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Rectangle()
                                .fill(selectedTab == 0 ? Color.appAccentOrange : Color.clear)
                                .frame(height: 3)
                                .cornerRadius(1.5)
                                .matchedGeometryEffect(id: "TabUnderline", in: tabNamespace, isSource: selectedTab == 0)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .tutorialStep(.gameCaptures)
                    
                    Button(action: { withAnimation { selectedTab = 1 } }) {
                        VStack(spacing: 6) {
                            Text(L10n.Gallery.wordsTab)
                                .font(.system(size: 18, weight: selectedTab == 1 ? .bold : .medium, design: .rounded))
                                .foregroundColor(selectedTab == 1 ? .appAccentOrange : .appTextSecondary.opacity(0.6))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Rectangle()
                                .fill(selectedTab == 1 ? Color.appAccentOrange : Color.clear)
                                .frame(height: 3)
                                .cornerRadius(1.5)
                                .matchedGeometryEffect(id: "TabUnderline", in: tabNamespace, isSource: selectedTab == 1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .tutorialStep(.myJournal)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
            } else {
                HStack {
                    Text(L10n.Gallery.capturesTab)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.appTextHeading)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 4)
                .tutorialStep(.gameCaptures)
            }
            
            let currentSubtitle = selectedTab == 0
                ? (viewModel.items.isEmpty ? L10n.Gallery.noCapturesYet : L10n.Gallery.objectsCollected(viewModel.items.count))
                : (viewModel.filteredVocabularyWords.isEmpty ? L10n.Gallery.noCapturesYet : L10n.Gallery.objectsCollected(viewModel.filteredVocabularyWords.count))
                
            HStack {
                Text(currentSubtitle)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.appTextSecondary.opacity(0.8))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            if selectedTab == 0 {
                if viewModel.items.isEmpty {
                    EmptyGalleryView()
                        .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    GalleryGridView(
                        items: viewModel.items,
                        onItemTapped: { item in
                            viewModel.onWordTapped(item)
                        }
                    )
                }
            } else {
                VStack(spacing: 0) {
                    CategoryFilterView(
                        categories: wordCategories,
                        localizedTitles: wordLocalizedTitles,
                        selectedCategory: Binding(
                            get: { viewModel.selectedDifficultyFilter ?? "All" },
                            set: { newValue in
                                viewModel.selectedDifficultyFilter = newValue == "All" ? nil : newValue
                            }
                        )
                    )
                    .padding(.bottom, 10)
                    
                    if viewModel.filteredVocabularyWords.isEmpty {
                        EmptyGalleryView(
                            title: L10n.Gallery.emptyFilterWordsTitle,
                            subtitle: L10n.Gallery.emptyFilterWordsSubtitle
                        )
                            .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 20) {
                                ForEach(viewModel.filteredVocabularyWords) { word in
                                    Button(action: {
                                        viewModel.onVocabularyWordTapped(word)
                                    }) {
                                        VocabularyWordCard(word: word, onSpeakTapped: {
                                            viewModel.onSpeakTapped(word)
                                        })
                                    }
                                    .buttonStyle(.plain)
                                    .transition(.scale(scale: 0.8).combined(with: .opacity))
                                }
                            }
                            .padding(20)
                        }
                    }
                }
            }
            .background(
                HomeBackgroundView()
                    .ignoresSafeArea()
            )
            
            if showTutorial {
                TutorialOverlayView(
                    bounds: tutorialBounds,
                    steps: tutorialSteps,
                    isPresented: $showTutorial
                )
            }
        }
        .coordinateSpace(name: "TutorialSpace")
        .onPreferenceChange(TutorialBoundsPreferenceKey.self) { bounds in
            self.tutorialBounds = bounds
        }
        .onAppear {
            viewModel.loadItems()
            if !viewModel.isLockScreenVocabularyEnabled {
                selectedTab = 0
            }
            if !hasSeenGalleryTutorial {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showTutorial = true
                    hasSeenGalleryTutorial = true
                }
            }
        }
        .appDialog(isPresented: $viewModel.showVocabularyDialog) {
            if let selectedWord = viewModel.selectedVocabularyWord {
                VocabularyWordDetailDialog(word: selectedWord, onSpeakTapped: {
                    viewModel.onSpeakTapped(selectedWord)
                }, onDismiss: {
                    viewModel.showVocabularyDialog = false
                    viewModel.selectedVocabularyWord = nil
                })
            } else {
                EmptyView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("VocabularyNotificationTapped"))) { _ in
            selectedTab = 1
            viewModel.loadItems()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                viewModel.loadItems()
            }
        }
    }
}

#Preview("LightTheme") {
    GalleryView(viewModel: Resolver.shared.resolve(GalleryViewModel.self))
}

#Preview("DarkTheme") {
    GalleryView(viewModel: Resolver.shared.resolve(GalleryViewModel.self))
        .preferredColorScheme(.dark)
}

