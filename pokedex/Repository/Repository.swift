//
//  Repository.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation
import Alamofire

protocol RepositoryProtocol {
    func getPokemonList(size: Int, completion: @escaping (PokemonList?) -> Void)
}

class Repository: RepositoryProtocol {
    static let shared = Repository()
    
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    
    func getPokemonList(size: Int, completion: @escaping (PokemonList?) -> Void) {
        let fullUrl = "\(baseURL)?limit=\(size)"
        AF.request(fullUrl).responseDecodable(of: PokemonList.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPokemonDetail(url: String, completion: @escaping (Pokemon?) -> Void) {
        AF.request(url).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}