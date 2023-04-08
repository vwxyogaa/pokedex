//
//  MyCollectionUseCase.swift
//  pokedex
//
//  Created by yxgg on 18/02/23.
//

import RxSwift

protocol MyCollectionUseCaseProtocol {
    func getMyCollections() -> Observable<[PokemonCollection]>
}

final class MyCollectionUseCase: MyCollectionUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getMyCollections() -> Observable<[PokemonCollection]> {
        return repository.getMyCollections()
    }
}
