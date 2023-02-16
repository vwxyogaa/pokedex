//
//  RemoteDataSource.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation
import RxSwift

final class RemoteDataSource {
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon"
    
    func getPokemonList(page: Int) -> Observable<PokemonList> {
        let limit = 20
        let offset = (page - 1) * limit
        let url = URL(string: baseUrl + "?offset=\(offset)&limit=\(limit)")!
        let data: Observable<PokemonList> = APIManager.shared.executeQuery(url: url, method: .get, params: nil)
        return data
    }
    
    func getPokemonDetail(id: Int) -> Observable<Pokemon> {
        let url = URL(string: baseUrl + "/\(id)")!
        let data: Observable<Pokemon> = APIManager.shared.executeQuery(url: url, method: .get, params: nil)
        return data
    }
}
