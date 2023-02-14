//
//  LocalRepository.swift
//  pokedex
//
//  Created by Panji Yoga on 14/02/23.
//

import Foundation
import CoreData
import UIKit

protocol LocalRepositoryProtocol {
    func catchPokemon(nickname: String, pokemon: Pokemon)
    func checkPokemonInCollection(pokemonId: Int?, completion: @escaping (_ isCatched: Bool, _ nickname: String?) -> Void)
    func getMyCollections(completion: @escaping ([PokemonCollection]) -> Void)
    func releasedPokemon(nickname: String, completion: @escaping () -> Void)
}

class LocalRepository: LocalRepositoryProtocol {
    static let shared = LocalRepository()
    
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
    
    func checkPokemonInCollection(pokemonId: Int?, completion: @escaping (_ isCatched: Bool, _ nickname: String?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyCollection")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                guard let nickname = data.value(forKey: "nickname") as? String, let pokemonData = data.value(forKey: "pokemon") as? Data, let pokemon = Utils.getPokemonFromData(data: pokemonData) else { return }
                if pokemon.id == pokemonId {
                    completion(true, nickname)
                    return
                }
            }
            completion(false, nil)
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
    
    func releasedPokemon(nickname: String, completion: @escaping () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContex = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyCollection")
        fetchRequest.predicate = NSPredicate(format: "nickname == %@", nickname)
        do {
            let result = try managedContex.fetch(fetchRequest)
            let objectToDelete = result.first as! NSManagedObject
            managedContex.delete(objectToDelete)
            do {
                try managedContex.save()
                completion()
            } catch {
                print("Failed to delete")
            }
        } catch {
            print("Failed retrieve")
        }
    }
}
