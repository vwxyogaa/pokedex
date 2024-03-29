//
//  DetailPokemonViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 08/02/23.
//

import RxSwift
import RxCocoa

class DetailPokemonViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let detailUseCase: DetailUseCaseProtocol
    
    private let _pokemon = BehaviorRelay<Pokemon?>(value: nil)
    
    init(detailUseCase: DetailUseCaseProtocol, pokemon: Pokemon?) {
        self.detailUseCase = detailUseCase
        _pokemon.accept(pokemon)
        super.init()
        self.checkPokemonInCollection(pokemonId: pokemon?.id)
    }
    
    var pokemon: Driver<Pokemon?> {
        return _pokemon.asDriver()
    }
    
    func checkPokemonInCollection(pokemonId: Int?) {
        self._isLoading.accept(true)
        guard let pokemonId else { return }
        detailUseCase.checkPokemonInCollection(pokemonId: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe { result, nickname in
                var pokemonWithNick = self._pokemon.value
                pokemonWithNick?.nickname = nickname
                self._pokemon.accept(pokemonWithNick)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
    
    func catchPokemon(nickname: String) {
        guard var pokemon = _pokemon.value else { return }
        pokemon.nickname = nickname
        detailUseCase.catchPokemon(nickname: nickname, pokemon: pokemon)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                var pokemonWithNick = pokemon
                pokemonWithNick.nickname = nickname
                self._pokemon.accept(pokemonWithNick)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func releasedPokemon() {
        self._isLoading.accept(true)
        guard let nickname = _pokemon.value?.nickname else { return }
        detailUseCase.releasedPokemon(nickname: nickname)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                var pokemonWithNick = self._pokemon.value
                pokemonWithNick?.nickname = nil
                self._pokemon.accept(pokemonWithNick)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            } onCompleted: {
                self._isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}
