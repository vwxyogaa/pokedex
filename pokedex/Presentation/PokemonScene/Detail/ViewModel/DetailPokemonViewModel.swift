//
//  DetailPokemonViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 08/02/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailPokemonViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let detailUseCase: DetailUseCaseProtocol
    
    private let _isCatched = BehaviorRelay<Bool>(value: false)
    let _pokemon = BehaviorRelay<Pokemon?>(value: nil)
    var nickname: String?
    
    init(detailUseCase: DetailUseCaseProtocol, pokemon: Pokemon?) {
        self.detailUseCase = detailUseCase
        _pokemon.accept(pokemon)
        super.init()
        self.checkPokemonInCollection(pokemonId: pokemon?.id)
    }
    
    var pokemon: Driver<Pokemon?> {
        return _pokemon.asDriver()
    }
    
    var isCatched: Driver<Bool> {
        return _isCatched.asDriver()
    }
    
    func checkPokemonInCollection(pokemonId: Int?) {
        guard let pokemonId else { return }
        detailUseCase.checkPokemonInCollection(pokemonId: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe { result, nickname in
                self.nickname = nickname
                self._isCatched.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func catchPokemon(nickname: String) {
        guard var pokemon = _pokemon.value else { return }
        pokemon.nickname = nickname
        detailUseCase.catchPokemon(nickname: nickname, pokemon: pokemon)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.nickname = nickname
                self._isCatched.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func releasedPokemon() {
        guard let nickname = nickname else { return }
        detailUseCase.releasedPokemon(nickname: nickname)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.nickname = nil
                self._isCatched.accept(!result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
