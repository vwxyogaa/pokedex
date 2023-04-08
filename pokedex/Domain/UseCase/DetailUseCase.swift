//
//  DetailUseCase.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import RxSwift

protocol DetailUseCaseProtocol {
    func checkPokemonInCollection(pokemonId: Int) -> Observable<(Bool, String?)>
    func catchPokemon(nickname: String, pokemon: Pokemon) -> Observable<Bool>
    func releasedPokemon(nickname: String) -> Observable<Bool>
}

final class DetailUseCase: DetailUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func checkPokemonInCollection(pokemonId: Int) -> Observable<(Bool, String?)> {
        return self.repository.checkPokemonInCollection(pokemonId: pokemonId)
    }
    
    func catchPokemon(nickname: String, pokemon: Pokemon) -> Observable<Bool> {
        return self.repository.catchPokemon(nickname: nickname, pokemon: pokemon)
    }
    
    func releasedPokemon(nickname: String) -> Observable<Bool> {
        return self.repository.releasedPokemon(nickname: nickname)
    }
}
