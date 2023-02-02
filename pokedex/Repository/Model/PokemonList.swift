//
//  PokemonList.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation

struct PokemonList: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonResults]?
}
