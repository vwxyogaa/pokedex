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
    
    let pokemonList: Observable<[PokemonResults]?> = Observable(nil)
    var pokemonDetail: [Pokemon] = []
    var completeRequest: Observable<Bool> = Observable(false)
    
    func getPokemonList() {
        group.enter()
        repository.getPokemonList(size: 10) { result in
            self.pokemonList.value = result?.results
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
            }
            self.semaphore.signal()
            self.group.leave()
        }
    }
    
    func notifyDispatchGroup() {
        group.notify(queue: .global()) {
            self.completeRequest.value = true
            print("all network request done")
        }
    }
}
