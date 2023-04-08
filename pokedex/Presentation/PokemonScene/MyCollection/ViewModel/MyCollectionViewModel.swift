//
//  MyCollectionViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 09/02/23.
//

import RxSwift
import RxCocoa

class MyCollectionViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let myCollectionUseCase: MyCollectionUseCaseProtocol
    
    private let _pokemon = BehaviorRelay<[PokemonCollection]>(value: [])
    
    init(myCollectionUseCase: MyCollectionUseCaseProtocol) {
        self.myCollectionUseCase = myCollectionUseCase
        super.init()
    }
    
    var pokemons: Driver<[PokemonCollection]> {
        return _pokemon.asDriver()
    }
    
    var pokemonsCount: Int {
        return _pokemon.value.count
    }
    
    func pokemon(at index: Int) -> PokemonCollection? {
        return _pokemon.value[safe: index]
    }
    
    func refresh() {
        getMyCollections()
    }
    
    func getMyCollections() {
        myCollectionUseCase.getMyCollections()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._pokemon.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
