//
//  Utils.swift
//  pokedex
//
//  Created by Panji Yoga on 08/02/23.
//

import Foundation

class Utils {
    static func getDataFromPokemon(pokemon: Pokemon) -> Data? {
        do {
            let data = try PropertyListEncoder.init().encode(pokemon)
            return data
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func getPokemonFromData(data: Data) -> Pokemon? {
        do {
            let packet = try PropertyListDecoder.init().decode(Pokemon.self, from: data)
            return packet
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
