//
//  DashboardViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation

class DashboardViewModel {
    private let repository = Repository.shared
    
    let pokemonList: Observable<[PokemonResults]?> = Observable(nil)
    
    func getPokemonInformation() {
        repository.getPokemonList(size: 50) { result in
            self.pokemonList.value = result?.results
        }
    }
}
