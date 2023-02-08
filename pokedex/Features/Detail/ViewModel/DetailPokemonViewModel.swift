//
//  DetailPokemonViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 08/02/23.
//

import Foundation

class DetailPokemonViewModel {
    private let repository = Repository.shared
    
    let pokemon: Observable<Pokemon?> = Observable(nil)
    let isCatched: Observable<Bool> = Observable(false)
    
    init(pokemon: Pokemon) {
        self.pokemon.value = pokemon
        self.getStatusPokemonInCollection(pokemonId: pokemon.id)
    }
    
    func catchPokemon(nickname: String) {
        guard let pokemon = pokemon.value else { return }
        repository.catchPokemon(nickname: nickname, pokemon: pokemon)
        self.isCatched.value = true
    }
    
    private func getStatusPokemonInCollection(pokemonId: Int?) {
        guard let pokemonId else { return }
        repository.checkPokemonInCollection(pokemonId: pokemonId) { isCatched in
            if isCatched {
                self.isCatched.value = true
            } else {
                self.isCatched.value = false
            }
        }
    }
}
