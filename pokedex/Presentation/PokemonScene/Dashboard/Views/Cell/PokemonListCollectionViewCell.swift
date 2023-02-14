//
//  PokemonListCollectionViewCell.swift
//  pokedex
//
//  Created by yxgg on 02/02/23.
//

import UIKit
import Kingfisher

class PokemonListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var namePokemonLabel: UILabel!
    @IBOutlet weak var numberPokemonLabel: UILabel!
    @IBOutlet weak var containerTypeOneView: UIView!
    @IBOutlet weak var typeOnePokemonLabel: UILabel!
    @IBOutlet weak var containerTypeTwoView: UIView!
    @IBOutlet weak var typeTwoPokemonLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    private func configureViews() {
        self.containerView.layer.cornerRadius = 10
        self.containerTypeOneView.layer.cornerRadius = 5
        self.containerTypeTwoView.layer.cornerRadius = 5
    }
    
    func configureContentDashboard(pokemon: Pokemon) {
        var typeTwo: String?
        if let types = pokemon.types, types.count > 1 {
            typeTwo = types.last?.type?.name?.capitalized
        }
        self.namePokemonLabel.text = pokemon.name?.capitalized
        self.numberPokemonLabel.text = pokemon.tag
        self.typeOnePokemonLabel.text = pokemon.types?.first?.type?.name?.capitalized
        self.typeTwoPokemonLabel.text = typeTwo ?? "-"
        if let imageUrl = pokemon.sprites?.versions?.generationV?.blackWhite?.animated?.frontDefault, let url = URL(string: imageUrl) {
            self.pokemonImageView.kf.setImage(with: url, placeholder: UIImage(named: "pokeball"))
        } else if let imageUrl = pokemon.sprites?.other?.officialArtwork?.frontDefault, let url = URL(string: imageUrl) {
            self.pokemonImageView.kf.setImage(with: url, placeholder: UIImage(named: "pokeball"))
        } else {
            self.pokemonImageView.image = UIImage(named: "pokeball")
        }
    }
    
    func configureContentMyCollection(myCollection: PokemonCollection) {
        var typeTwo: String?
        if let types = myCollection.pokemon.types, types.count > 1 {
            typeTwo = types.last?.type?.name?.capitalized
        }
        self.namePokemonLabel.text = myCollection.pokemon.name?.capitalized
        self.numberPokemonLabel.text = "(\(myCollection.nickname))"
        self.typeOnePokemonLabel.text = myCollection.pokemon.types?.first?.type?.name?.capitalized
        self.typeTwoPokemonLabel.text = typeTwo ?? "-"
        if let imageUrl = myCollection.pokemon.sprites?.versions?.generationV?.blackWhite?.animated?.frontDefault, let url = URL(string: imageUrl) {
            self.pokemonImageView.kf.setImage(with: url, placeholder: UIImage(named: "pokeball"))
        } else if let imageUrl = myCollection.pokemon.sprites?.other?.officialArtwork?.frontDefault, let url = URL(string: imageUrl) {
            self.pokemonImageView.kf.setImage(with: url, placeholder: UIImage(named: "pokeball"))
        } else {
            self.pokemonImageView.image = UIImage(named: "pokeball")
        }
    }
}
