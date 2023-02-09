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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        if let pokemonDetail {
            nameLabel.text = pokemonDetail.name?.capitalized
            heightLabel.text = String(pokemonDetail.height ?? 0)
            weightLabel.text = String(pokemonDetail.weight ?? 0)
            let typesPokemon: [String]? = pokemonDetail.types?.compactMap({ types in
                if let name = types.type?.name {
                    return name
                }
                return nil
            })
            typesLabel.text = typesPokemon?.joined(separator: ", ").capitalized
            let abilitiesPokemon: [String]? = pokemonDetail.abilities?.compactMap({ abilities in
                if let name = abilities.ability?.name {
                    return name
                }
                return nil
            })
            abilitiesLabel.text = abilitiesPokemon?.joined(separator: ", ").capitalized
        }
    }
}
