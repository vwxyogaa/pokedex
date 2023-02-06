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
    
    func configureContent(name: String, number: String, typeOne: String, typeTwo: String, imageUrl: String) {
        self.namePokemonLabel.text = name
        self.numberPokemonLabel.text = number
        self.typeOnePokemonLabel.text = typeOne
        self.typeTwoPokemonLabel.text = typeTwo
        if let url = URL(string: imageUrl) {
            self.pokemonImageView.kf.setImage(with: url, placeholder: UIImage(named: "pokeball"))
        }
    }
}
