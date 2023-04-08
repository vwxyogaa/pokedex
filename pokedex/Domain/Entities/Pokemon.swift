//
//  Pokemon.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

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
    var nickname: String?
    
    var tag: String {
        get {
            guard let id = id else { return "###" }
            switch String(id).count {
            case 1: return "#00\(id)"
            case 2: return "#0\(id)"
            default: return "#\(id)"
            }
        }
    }
}

struct PokemonSprites: Codable {
    let other: OtherSprites?
    let versions: VersionsSprites?
    
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
    
    struct VersionsSprites: Codable {
        let generationV: GenerationV?
        
        enum CodingKeys: String, CodingKey {
            case generationV = "generation-v"
        }
        
        struct GenerationV: Codable {
            let blackWhite: BlackWhite?
            
            enum CodingKeys: String, CodingKey {
                case blackWhite = "black-white"
            }
            
            struct BlackWhite: Codable {
                let animated: OtherSprites.OfficialArtwork?
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
