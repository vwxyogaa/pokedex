//
//  Repository.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - Remote
    func getPokemonList(page: Int) -> Observable<[Int]>
    func getPokemonDetail(id: Int) -> Observable<Pokemon>
    // MARK: - Locale
    func checkPokemonInCollection(pokemonId: Int) -> Observable<(Bool, String?)>
    func catchPokemon(nickname: String, pokemon: Pokemon) -> Observable<Bool>
    func releasedPokemon(nickname: String) -> Observable<Bool>
    func getMyCollections() -> Observable<[PokemonCollection]>
}

final class Repository: NSObject {
    typealias PokemonInstance = (RemoteDataSource, LocalDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    fileprivate let local: LocalDataSource
    
    init(remote: RemoteDataSource, local: LocalDataSource) {
        self.remote = remote
        self.local = local
    }
    
    static let sharedInstance: PokemonInstance = { remote, local in
        return Repository(remote: remote, local: local)
    }
}

extension Repository: RepositoryProtocol {
    // MARK: - Remote
    func getPokemonList(page: Int) -> Observable<[Int]> {
        return remote.getPokemonList(page: page)
            .compactMap { $0.results?.compactMap({ $0.id }) }
    }
    
    func getPokemonDetail(id: Int) -> Observable<Pokemon> {
        return remote.getPokemonDetail(id: id)
    }
    
    // MARK: - Locale
    func checkPokemonInCollection(pokemonId: Int) -> Observable<(Bool, String?)> {
        return local.checkPokemonInCollection(pokemonId: pokemonId)
    }
    
    func catchPokemon(nickname: String, pokemon: Pokemon) -> Observable<Bool> {
        return local.catchPokemon(nickname: nickname, pokemon: pokemon)
    }
    
    func releasedPokemon(nickname: String) -> Observable<Bool> {
        return local.releasedPokemon(nickname: nickname)
    }
    
    func getMyCollections() -> Observable<[PokemonCollection]> {
        return local.getMyCollections()
    }
}
