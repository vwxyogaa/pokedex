//
//  DashboardViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let dashboardUseCase: DashboardUseCaseProtocol
    
    // MARK: - dispatch
//    let group = DispatchGroup()
//    let semaphore = DispatchSemaphore(value: 0)
//    let queue = DispatchQueue(label: "com.gcd.Queue")
    
    // MARK: - pagination
//    var page = 1
//    private var totalPage = 1
//    private var canLoadNextPage = false
//    private let pageSize = 20
    
//    var pokemonList: [PokemonResults] = []
//    var pokemonDetail: [Pokemon] = []
//    let isLoading: Observable<Bool> = Observable(false)
//    let completeRequest: Observable<Bool> = Observable(false)
    
    private var pokemonResults = [Pokemon]()
    private var pokemonResultsCount = 0
    private var page = 1
    private var canLoadNextPage = false
    
    private let _pokemons = BehaviorRelay<[Pokemon]>(value: [])
    
    init(dashboardUseCase: DashboardUseCaseProtocol) {
        self.dashboardUseCase = dashboardUseCase
        super.init()
        getPokemonList()
    }
    
    var pokemons: Driver<[Pokemon]> {
        return _pokemons.asDriver()
    }
    
    var pokemonsCount: Int {
        return _pokemons.value.count
    }
    
    func pokemon(at index: Int) -> Pokemon? {
        return _pokemons.value[safe: index]
    }
    
    func refresh() {
        pokemonResults = []
        pokemonResultsCount = 0
        page = 1
        getPokemonList()
    }
    
//    private func calculateTotalPage(totalData: Int) {
//        totalPage = (totalData % pageSize == 0) ? totalData/pageSize : (totalData/pageSize + 1)
//    }
    
    func getPokemonList() {
        dashboardUseCase.getPokemonList(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.pokemonResultsCount += result.count
                result.forEach { id in
                    self.getPokemonDetail(id: id)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func getPokemonDetail(id: Int) {
        dashboardUseCase.getPokemonDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.pokemonResults.append(result)
                if self.pokemonResults.count == self.pokemonResultsCount {
                    self.page += 1
                    self.canLoadNextPage = false
                    self._pokemons.accept(self.pokemonResults.sorted { $0.id ?? 0 < $1.id ?? 0})
                }
            }
            .disposed(by: disposeBag)
    }
    
//    func getPokemonList() {
//        isLoading.value = true
//        group.enter()
//        remoteRepository.getPokemonList(page: page, size: pageSize) { result, errorConnection in
//            if errorConnection == true {
//                //                 if wanna clear data
//                //                self.pokemonList.removeAll()
//                //                self.pokemonDetail.removeAll()
//                self.group.leave()
//            }
//            if self.page == 1 {
//                self.calculateTotalPage(totalData: result?.count ?? 0)
//                self.pokemonList = result?.results ?? []
//                guard let pokemon = result?.results else { return }
//                DispatchQueue.global().async {
//                    for poke in pokemon {
//                        self.getPokemonDetail(name: poke.name ?? "")
//                        self.semaphore.wait()
//                    }
//                    self.group.leave()
//                }
//            } else {
//                let newInformations = result?.results
//                self.pokemonList.append(contentsOf: newInformations ?? [])
//                guard let pokemon = newInformations else { return }
//                DispatchQueue.global().async {
//                    for poke in pokemon {
//                        self.getPokemonDetail(name: poke.name ?? "")
//                        self.semaphore.wait()
//                    }
//                    self.group.leave()
//                }
//            }
//            self.canLoadNextPage = true
//            self.page += 1
//        }
//        notifyDispatchGroup()
//    }
    
//    func getPokemonDetail(name: String) {
//        group.enter()
//        remoteRepository.getPokemonDetail(name: name) { result in
//            if let result {
//                self.pokemonDetail.append(result)
//            }
//            self.semaphore.signal()
//            self.group.leave()
//        }
//    }
    
    func loadNextPage(index: Int) {
        if !canLoadNextPage {
            if _pokemons.value.count - 2 == index {
                canLoadNextPage = true
                getPokemonList()
            }
        }
    }
//
//    func loadNextPage(lastIndex: Int) {
//        if page <= totalPage && canLoadNextPage {
//            let totalData = pokemonList.count - 2
//            if lastIndex == totalData {
//                getPokemonList()
//            }
//        }
//    }
//
//    func notifyDispatchGroup() {
//        group.notify(queue: .global()) {
//            self.isLoading.value = false
//            self.completeRequest.value = true
//            print("all network request done in page: \(self.page - 1)")
//        }
//    }
}
