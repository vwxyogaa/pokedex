//
//  Repository.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation
import Alamofire

protocol RepositoryProtocol {
    func getPokemonList(page: Int, size: Int, completion: @escaping (PokemonList?) -> Void)
    func getPokemonDetail(name: String, completion: @escaping (Pokemon?) -> Void)
}

class Repository: RepositoryProtocol {
    static let shared = Repository()
    
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    
    func getPokemonList(page: Int, size: Int, completion: @escaping(PokemonList?) -> Void) {
        let offset = (page - 1) * size
        let fullUrl = "\(baseURL)?offset=\(offset)&limit=\(size)"
        AF.request(fullUrl).validate().responseDecodable(of: PokemonList.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPokemonDetail(name: String, completion: @escaping(Pokemon?) -> Void) {
        let fullUrl = "\(baseURL)/\(name)"
        AF.request(fullUrl).validate().responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
