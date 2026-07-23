//
//  AllWorldsView.swift
//  Lingua Quest
//
//  Created by Omar Khaled Jaafar on 19/07/2026.
//

import SwiftUI

struct AllWorldsView: View {
    @State var viewModel: AllWorldsViewModel
    
    var body: some View {
        AllWorldsContentView(
            isLoading: viewModel.isLoading,
            selectedFilter: viewModel.selectedFilter,
            worlds: viewModel.displayWorlds,
            onBackTapped: { viewModel.onBackTapped() },
            onFilterSelected: { viewModel.selectFilter($0) },
            onWorldTapped: { viewModel.onWorldTapped($0) }
        )
        .navigationBarHidden(true)
    }
}
