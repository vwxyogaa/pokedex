//
//  Pokemon.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation

struct Pokemon: Codable {
    let id: Int?
    let name: String?
    let sprites: PokemonSprites?
    let height: Int?
    let weight: Int?
    let types: [PokemonTypes]?
    let abilities: [PokemonAbilities]?
    let stats: [PokemonStats]?
    let moves: [PokemonMoves]?
}

struct PokemonSprites: Codable {
    let other: OtherSprites?
    
    struct OtherSprites: Codable {
        let officialArtwork: OfficialArtwork?
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
        
        struct OfficialArtwork: Codable {
            let frontDefault: String?
            
            enum CodingKeys: String, CodingKey {
                case frontDefault = "front_default"
            }
        }
    }
}

struct PokemonTypes: Codable {
    let type: PokemonResults?
}

struct PokemonAbilities: Codable {
    let ability: PokemonResults?
}

struct PokemonStats: Codable {
    let baseStat: Int?
    let stat: PokemonResults?
    
    enum CodingKeys: String, CodingKey {
        case stat
        case baseStat = "base_stat"
    }
}

struct PokemonMoves: Codable {
    let move: PokemonResults?
}
