//
//  MyCollectionViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 09/02/23.
//

import Foundation

class MyCollectionViewModel {
    private let repository = Repository.shared
    
    let myCollections: Observable<[PokemonCollection]> = Observable([])
    
    func getMyCollections(){
        repository.getMyCollections { myCollections in
            self.myCollections.value = myCollections
        }
    }
}
