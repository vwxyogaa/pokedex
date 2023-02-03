//
//  AboutViewController.swift
//  pokedex
//
//  Created by yxgg on 03/02/23.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    
    var pokemonDetail: Pokemon?
    var typesPokemon: [String] = []
    var abilitiesPokemon: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        if let pokemonDetail {
            nameLabel.text = pokemonDetail.name?.capitalized
            heightLabel.text = String(pokemonDetail.height ?? 0)
            weightLabel.text = String(pokemonDetail.weight ?? 0)
            pokemonDetail.types?.forEach({ pokeType in
                self.typesPokemon.append(pokeType.type?.name?.capitalized ?? "")
            })
            typesLabel.text = typesPokemon.joined(separator: ", ")
            pokemonDetail.abilities?.forEach({ pokeAbilities in
                self.abilitiesPokemon.append(pokeAbilities.ability?.name?.capitalized ?? "")
            })
            abilitiesLabel.text = abilitiesPokemon.joined(separator: ", ")
        }
    }
}
