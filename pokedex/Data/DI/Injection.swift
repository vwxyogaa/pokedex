//
//  Injection.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation

final class Injection {
    func provideDashboardUseCase() -> DashboardUseCaseProtocol {
        let remoteRepository = provideRepository()
        return DashboardUseCase(repository: remoteRepository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        return Repository.sharedInstance(remoteDataSource)
    }
}
