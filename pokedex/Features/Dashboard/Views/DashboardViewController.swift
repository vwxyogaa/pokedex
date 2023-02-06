//
//  DashboardViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObservers()
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func configureViews() {
        configureBackgroundContainerView()
        configureCollectionView()
    }
    
    private func configureData() {
        viewModel.getPokemonList()
    }
    
    private func initObservers() {
        viewModel.isLoading.observe(on: self) { isLoading in
            self.manageLoadingActivity(isLoading: isLoading)
        }
        
        viewModel.completeRequest.observe(on: self) { requestComplete in
            if requestComplete {
                self.pokemonListCollectionView.reloadData()
            }
        }
    }
    
    private func configureBackgroundContainerView() {
        backgroundContainerView.clipsToBounds = true
        backgroundContainerView.layer.cornerRadius = 10
        backgroundContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
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
        return viewModel.pokemonList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCollectionViewCell", for: indexPath) as? PokemonListCollectionViewCell else { return UICollectionViewCell() }
        let pokemon = viewModel.pokemonDetail[indexPath.row]
        cell.configureContent(name: pokemon.name?.capitalized ?? "-", number: "#\(pokemon.id ?? 0)", typeOne: pokemon.types?.first?.type?.name?.capitalized ?? "-", typeTwo: pokemon.types?.last?.type?.name?.capitalized ?? "-", imageUrl: pokemon.sprites?.other?.officialArtwork?.frontDefault ?? "")
        viewModel.loadNextPage(lastIndex: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailPokemonViewController()
        detailViewController.pokemonDetail = viewModel.pokemonDetail[indexPath.row]
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
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
