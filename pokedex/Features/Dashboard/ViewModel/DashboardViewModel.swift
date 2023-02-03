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
    
    func getPokemonInformation() {
        group.enter()
        repository.getPokemonList(size: 20) { result in
            self.pokemonList.value = result?.results
            guard let pokemon = result?.results else { return }
            DispatchQueue.global().async {
                for results in pokemon {
                    self.getPokemonDetail(url: results.url ?? "")
                    self.semaphore.wait()
                }
                self.group.leave()
            }
        }
        notifyDispatchGroup()
    }
    
    func getPokemonDetail(url: String) {
        group.enter()
        self.repository.getPokemonDetail(url: url) { result in
            if let result {
                self.pokemonDetail.append(result)
                self.semaphore.signal()
            }
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
