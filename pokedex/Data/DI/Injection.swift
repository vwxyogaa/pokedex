//
//  Injection.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation

final class Injection {
    func provideDashboardUseCase() -> DashboardUseCaseProtocol {
        let repository = provideRepository()
        return DashboardUseCase(repository: repository)
    }
    
    func provideDetailUeCase() -> DetailUseCaseProtocol {
        let repository = provideRepository()
        return DetailUseCase(repository: repository)
    }
    
    func provideMyCollectionsUseCase() -> MyCollectionUseCaseProtocol {
        let repository = provideRepository()
        return MyCollectionUseCase(repository: repository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        let localDataSource = LocalDataSource()
        return Repository.sharedInstance(remoteDataSource, localDataSource)
    }
}
