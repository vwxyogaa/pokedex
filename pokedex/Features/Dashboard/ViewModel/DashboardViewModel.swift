//
//  DashboardViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation

class DashboardViewModel {
    private let repository = Repository.shared
    
    // MARK: - dispatch
    let group = DispatchGroup()
    let semaphore = DispatchSemaphore(value: 0)
    let queue = DispatchQueue(label: "com.gcd.Queue")
    
    // MARK: - pagination
    private var page = 1
    private var totalPage = 1
    private var canLoadNextPage = false
    private let pageSize = 20
    
    var pokemonList: [PokemonResults]? = []
    var pokemonDetail: [Pokemon] = []
    let isLoading: Observable<Bool> = Observable(false)
    var completeRequest: Observable<Bool> = Observable(false)
    
    private func calculateTotalPage(totalData: Int) {
        totalPage = (totalData % pageSize == 0) ? totalData/pageSize : (totalData/pageSize + 1)
    }
    
    func getPokemonList() {
        isLoading.value = true
        group.enter()
        repository.getPokemonList(page: page, size: pageSize) { result in
            if self.page == 1 {
                self.calculateTotalPage(totalData: result?.count ?? 0)
                self.pokemonList = result?.results
                guard let pokemon = result?.results else { return }
                DispatchQueue.global().async {
                    for poke in pokemon {
                        self.getPokemonDetail(name: poke.name ?? "")
                        self.semaphore.wait()
                    }
                    self.group.leave()
                }
            } else {
                let newInformations = result?.results
                self.pokemonList?.append(contentsOf: newInformations ?? [])
                guard let pokemon = newInformations else { return }
                DispatchQueue.global().async {
                    for poke in pokemon {
                        self.getPokemonDetail(name: poke.name ?? "")
                        self.semaphore.wait()
                    }
                    self.group.leave()
                }
            }
            self.canLoadNextPage = true
            self.page += 1
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
    
    func loadNextPage(lastIndex: Int) {
        if page <= totalPage && canLoadNextPage {
            let totalData = (pokemonList?.count ?? 2) - 2
            if lastIndex == totalData {
                getPokemonList()
            }
        }
    }
    
    func notifyDispatchGroup() {
        group.notify(queue: .global()) {
            self.isLoading.value = false
            self.completeRequest.value = true
            print("all network request done in page: \(self.page - 1)")
        }
    }
}
