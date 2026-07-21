//
//  HomeRepositoryImpl.swift
//  Lingua Quest
//
//  Created by TaqieAllah on 20/07/2026.
//

import Foundation

struct HomeRepositoryImpl: HomeRepositoryProtocol {
    private let remoteDataSource: HomeRemoteDataSourceProtocol

    init(remoteDataSource: HomeRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getHomeData() async throws -> HomeData {
        let response = try await remoteDataSource.getHomeData()
        return response.toDomain()
    }
}
