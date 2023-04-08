//
//  DashboardViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import RxSwift
import RxCocoa

class DashboardViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let dashboardUseCase: DashboardUseCaseProtocol
    
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
    
    private var isSearch: Bool {
        return _pokemons.value.count <= pokemonResultsCount - 1
    }
    
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
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func loadNextPage(index: Int) {
        if !canLoadNextPage && !isSearch {
            if _pokemons.value.count - 2 == index {
                canLoadNextPage = true
                getPokemonList()
            }
        }
    }
    
    func searchPokemons(query: String?) {
        guard let query, !query.isEmpty else {
            _pokemons.accept(pokemonResults)
            return
        }
        let filterPokemon = pokemonResults.filter { $0.name?.lowercased().contains(query.lowercased()) == true }
        _pokemons.accept(filterPokemon)
    }
}
