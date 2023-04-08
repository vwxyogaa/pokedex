//
//  DashboardUseCase.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import RxSwift

protocol DashboardUseCaseProtocol {
    func getPokemonList(page: Int) -> Observable<[Int]>
    func getPokemonDetail(id: Int) -> Observable<Pokemon>
}

final class DashboardUseCase: DashboardUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getPokemonList(page: Int) -> Observable<[Int]> {
        return self.repository.getPokemonList(page: page)
    }
    
    func getPokemonDetail(id: Int) -> Observable<Pokemon> {
        return self.repository.getPokemonDetail(id: id)
    }
}
