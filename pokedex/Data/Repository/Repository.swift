//
//  Repository.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - remote
    func getPokemonList(page: Int) -> Observable<[Int]>
    func getPokemonDetail(id: Int) -> Observable<Pokemon>
    // MARK: - local
}

final class Repository: NSObject {
    typealias PokemonInstance = (RemoteDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    
    private init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: PokemonInstance = { remote in
        return Repository(remote: remote)
    }
}

extension Repository: RepositoryProtocol {
    func getPokemonList(page: Int) -> Observable<[Int]> {
        return self.remote.getPokemonList(page: page)
            .compactMap { $0.results?.compactMap({ $0.id }) }
    }
    
    func getPokemonDetail(id: Int) -> Observable<Pokemon> {
        return self.remote.getPokemonDetail(id: id)
    }
}
