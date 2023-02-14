//
//  MyCollectionViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 09/02/23.
//

import Foundation

class MyCollectionViewModel {
    private let localRepository = LocalRepository.shared
    
    let myCollections: Observable<[PokemonCollection]> = Observable([])
    
    func getMyCollections(){
        localRepository.getMyCollections { myCollections in
            self.myCollections.value = myCollections
        }
    }
}
