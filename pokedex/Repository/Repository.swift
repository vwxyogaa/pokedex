//
//  Repository.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation
import Alamofire
import CoreData
import UIKit

protocol RepositoryProtocol {
    func getPokemonList(page: Int, size: Int, completion: @escaping (PokemonList?) -> Void)
    func getPokemonDetail(name: String, completion: @escaping (Pokemon?) -> Void)
    func catchPokemon(nickname: String, pokemon: Pokemon)
    func checkPokemonInCollection(pokemonId: Int?, completion: @escaping (_ isCatched: Bool) -> Void)
    func getMyCollections(completion: @escaping ([PokemonCollection]) -> Void)
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
    
    func catchPokemon(nickname: String, pokemon: Pokemon) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let myCollectionEntity = NSEntityDescription.entity(forEntityName: "MyCollection", in: managedContext) else { return }
        let myCollection = NSManagedObject(entity: myCollectionEntity, insertInto: managedContext)
        myCollection.setValue(nickname, forKey: "nickname")
        let pokemonData = Utils.getDataFromPokemon(pokemon: pokemon)
        myCollection.setValue(pokemonData, forKey: "pokemon")
        do {
            try managedContext.save()
        } catch {
            print("Could not save.")
        }
    }
    
    func checkPokemonInCollection(pokemonId: Int?, completion: @escaping (_ isCatched: Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyCollection")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                guard let pokemonData = data.value(forKey: "pokemon") as? Data, let pokemon = Utils.getPokemonFromData(data: pokemonData) else { return }
                if pokemon.id == pokemonId {
                    completion(true)
                    return
                }
            }
            completion(false)
        } catch {
            print("Failed retrieve")
        }
    }
    
    func getMyCollections(completion: @escaping ([PokemonCollection]) -> Void) {
        var collections: [PokemonCollection] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyCollection")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                guard let nickname = data.value(forKey: "nickname") as? String, let pokemonData = data.value(forKey: "pokemon") as? Data, let pokemon = Utils.getPokemonFromData(data: pokemonData) else { continue }
                let collection = PokemonCollection(nickname: nickname, pokemon: pokemon)
                collections.append(collection)
            }
            completion(collections)
        } catch {
            print("Failed retrieve")
        }
    }
}
