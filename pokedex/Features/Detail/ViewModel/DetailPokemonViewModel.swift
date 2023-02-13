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
    var nickname: String?
    
    init(pokemon: Pokemon) {
        self.pokemon.value = pokemon
        self.getStatusPokemonInCollection(pokemonId: pokemon.id)
    }
    
    init(myCollection: PokemonCollection) {
        self.isCatched.value = true
        self.nickname = myCollection.nickname
        self.pokemon.value = myCollection.pokemon
    }
    
    func catchPokemon(nickname: String) {
        guard let pokemon = pokemon.value else { return }
        repository.catchPokemon(nickname: nickname, pokemon: pokemon)
        self.isCatched.value = true
        self.nickname = nickname
    }
    
    private func getStatusPokemonInCollection(pokemonId: Int?) {
        guard let pokemonId else { return }
        repository.checkPokemonInCollection(pokemonId: pokemonId) { isCatched, nickname in
            if isCatched {
                self.isCatched.value = true
                self.nickname = nickname
            } else {
                self.isCatched.value = false
            }
        }
    }
    
    func releasedPokemon() {
        guard let nickname = nickname else { return }
        repository.releasedPokemon(nickname: nickname) {
            self.isCatched.value = false
            self.nickname = nil
        }
    }
}