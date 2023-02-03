//
//  DashboardViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var searchPokemonTextField: UITextField!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObservers()
        configureData()
    }
    
    private func configureViews() {
        configureNavigationBar()
        configureSearchPokemonTextField()
        configureCollectionView()
    }
    
    private func configureData() {
        viewModel.getPokemonInformation()
    }
    
    private func initObservers() {
        viewModel.completeRequest.observe(on: self) { requestComplete in
            if requestComplete {
                self.pokemonListCollectionView.reloadData()
            }
        }
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Pokedex"
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        backgroundContainerView.clipsToBounds = true
        backgroundContainerView.layer.cornerRadius = 10
        backgroundContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private func configureSearchPokemonTextField() {
        self.searchPokemonTextField.layer.cornerRadius = 10
        self.searchPokemonTextField.layer.masksToBounds = true
        searchPokemonTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
    
    private func configureCollectionView() {
        self.pokemonListCollectionView.register(UINib(nibName: "PokemonListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonListCollectionViewCell")
        self.pokemonListCollectionView.dataSource = self
        self.pokemonListCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemonList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCollectionViewCell", for: indexPath) as? PokemonListCollectionViewCell else { return UICollectionViewCell() }
        let pokemon = viewModel.pokemonList.value?[indexPath.row]
        let pokemonDetail = viewModel.pokemonDetail[indexPath.row]
        cell.configureContent(name: pokemon?.name ?? "-", number: "#\(indexPath.row + 1)", typeOne: pokemonDetail.types?.first?.type?.name ?? "-", typeTwo: pokemonDetail.types?.last?.type?.name ?? "-", imageUrl: pokemonDetail.sprites?.other?.officialArtwork?.frontDefault ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
}
