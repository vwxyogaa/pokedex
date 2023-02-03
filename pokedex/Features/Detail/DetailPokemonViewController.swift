//
//  DetailPokemonViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 03/02/23.
//

import UIKit
import Kingfisher

class DetailPokemonViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var numberPokemonLabel: UILabel!
    @IBOutlet weak var namePokemonLabel: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var statsBackgroundView: UIView!
    
    var pokemonDetail: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureViews() {
        configureNavigationBar()
        configureBackButton()
        configureStatsBackgroundView()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureBackButton() {
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func configureStatsBackgroundView() {
        statsBackgroundView.clipsToBounds = true
        statsBackgroundView.layer.cornerRadius = 50
        statsBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    private func configureData() {
        guard let number = pokemonDetail?.id else { return }
        self.numberPokemonLabel.text = "#\(number)"
        self.namePokemonLabel.text = pokemonDetail?.name?.localizedCapitalized
        let image = pokemonDetail?.sprites?.other?.officialArtwork?.frontDefault ?? ""
        if let url = URL(string: image) {
            self.imagePokemon.kf.setImage(with: url)
        }
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
