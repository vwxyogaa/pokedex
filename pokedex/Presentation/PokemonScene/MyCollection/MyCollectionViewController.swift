//
//  MyCollectionViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class MyCollectionViewController: UIViewController {
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    var viewModel: MyCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.viewModel.getMyCollections()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        traitCollection.userInterfaceStyle == .dark ? .darkContent : .lightContent
    }
    
    private func configureViews() {
        configureBackgroundContainerView()
        configureCollectionView()
    }
    
    private func initObservers() {
        viewModel.myCollections.observe(on: self) { pokeCollection in
            self.pokemonListCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configureBackgroundContainerView() {
        backgroundContainerView.layer.cornerRadius = 10
        backgroundContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundContainerView.clipsToBounds = true
    }
    
    private func configureCollectionView() {
        self.pokemonListCollectionView.register(UINib(nibName: "PokemonListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonListCollectionViewCell")
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.pokemonListCollectionView.addSubview(refreshControl)
        self.pokemonListCollectionView.dataSource = self
        self.pokemonListCollectionView.delegate = self
    }
    
    // MARK: - action
    @objc
    private func refreshData() {
        self.refreshControl.beginRefreshing()
        self.viewModel.getMyCollections()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MyCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (viewModel.myCollections.value.count == 0) {
            self.pokemonListCollectionView.setEmptyMessage("You don't have any pokemon in bag")
        } else {
            self.pokemonListCollectionView.restore()
        }
        return viewModel.myCollections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCollectionViewCell", for: indexPath) as? PokemonListCollectionViewCell else { return UICollectionViewCell() }
        let myCollection = viewModel.myCollections.value[indexPath.row]
        cell.configureContentMyCollection(myCollection: myCollection)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailPokemonViewController()
        let detailPokemonViewModel = DetailPokemonViewModel(myCollection: viewModel.myCollections.value[indexPath.row])
        detailViewController.viewModel = detailPokemonViewModel
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpaceHorizontal: CGFloat = 15 * (2 + 1)
        let paddingSpaceVertical: CGFloat = 8 * (7 + 1)
        let availableWidth = self.view.frame.width - paddingSpaceHorizontal
        let availableHeight = self.view.frame.height - paddingSpaceVertical
        let widthPerItem = (availableWidth / 2)
        let heightPerItem = (availableHeight / 6)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}
