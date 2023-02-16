//
//  PokemonResults.swift
//  pokedex
//
//  Created by Panji Yoga on 02/02/23.
//

import Foundation

struct PokemonResults: Codable {
    let name: String?
    let url: String?
}

extension PokemonResults {
    var id: Int {
        get {
            guard let url = self.url else { return 0 }
            let id = url.split(separator: "/").filter { !$0.isEmpty }
            return Int(id.last ?? "0") ?? 0
        }
    }
}
