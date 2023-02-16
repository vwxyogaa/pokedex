//
//  RemoteRepository.swift
//  pokedex
//
//  Created by Panji Yoga on 14/02/23.
//

import Foundation
import Alamofire

//protocol RemoteRepositoryProtocol {
//    func getPokemonList(page: Int, size: Int, completion: @escaping (PokemonList?, _ errorConnection: Bool?) -> Void)
//    func getPokemonDetail(name: String, completion: @escaping (Pokemon?) -> Void)
//}
//
//class RemoteRepository: RemoteRepositoryProtocol {
//    static let shared = RemoteRepository()
//
//    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
//
//    func getPokemonList(page: Int, size: Int, completion: @escaping(PokemonList?, _ errorConnection: Bool?) -> Void) {
//        let offset = (page - 1) * size
//        let fullUrl = "\(baseURL)?offset=\(offset)&limit=\(size)"
//        AF.request(fullUrl).validate().responseDecodable(of: PokemonList.self) { response in
//            switch response.result {
//            case .success(let data):
//                completion(data, false)
//            case .failure:
//                completion(nil, true)
//            }
//        }
//    }
//
//    func getPokemonDetail(name: String, completion: @escaping(Pokemon?) -> Void) {
//        let fullUrl = "\(baseURL)/\(name)"
//        AF.request(fullUrl).validate().responseDecodable(of: Pokemon.self) { response in
//            switch response.result {
//            case .success(let data):
//                completion(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
