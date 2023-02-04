//
//  DashboardViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation

class DashboardViewModel {
    private let repository = Repository.shared
    let group = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 0)
    let queue = DispatchQueue(label: "com.gcd.Queue")
    
    var pokemonList: [PokemonResults]? = []
    var pokemonDetail: [Pokemon] = []
    let pokemons: Observable<[Pokemon]?> = Observable(nil)
    
    func getPokemonList() {
        group.enter()
        repository.getPokemonList(size: 10) { result in
            self.pokemonList = result?.results
            guard let pokemon = result?.results else { return }
            DispatchQueue.global().async {
                for poke in pokemon {
                    self.getPokemonDetail(name: poke.name ?? "")
                    self.semaphore.wait()
                }
                self.group.leave()
            }
        }
        notifyDispatchGroup()
    }
    
    func getPokemonDetail(name: String) {
        group.enter()
        self.repository.getPokemonDetail(name: name) { result in
            if let result {
                self.pokemonDetail.append(result)
                self.pokemons.value = self.pokemonDetail
            }
            self.semaphore.signal()
            self.group.leave()
        }
    }
    
    func searchPokemon(query: String) {
        if query.isEmpty {
            self.pokemons.value = pokemonDetail
        } else {
            let filteredPokemon = self.pokemons.value?.filter({
                $0.name?.lowercased().contains(query.lowercased()) == true
            })
            self.pokemons.value = filteredPokemon
        }
    }
    
    func notifyDispatchGroup() {
        group.notify(queue: .global()) {
            print("all network request done")
        }
    }
}
