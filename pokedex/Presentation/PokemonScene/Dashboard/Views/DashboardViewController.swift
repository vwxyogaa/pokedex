//
//  DashboardViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit
import RxSwift

class DashboardViewController: UIViewController {
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var pokemonSearchTextField: UITextField!
    @IBOutlet weak var pokemonListCollectionView: UICollectionView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: DashboardViewModel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        initObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        traitCollection.userInterfaceStyle == .dark ? .darkContent : .lightContent
    }
    
    // MARK: - Helpers
    private func configureViews() {
        configureBackgroundContainerView()
        configureSearchTextField()
        configureCollectionView()
    }
    
    private func initObservers() {
        viewModel.pokemons.drive(onNext: { [weak self] pokemon in
            if pokemon.isEmpty {
                self?.pokemonListCollectionView.setBackground(imageName: "ic_empty_items", messageImage: "Not Found")
            } else {
                self?.pokemonListCollectionView.clearBackground()
            }
            self?.pokemonListCollectionView.reloadData()
            self?.pokemonListCollectionView.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.manageLoadingActivity(isLoading: isLoading)
        }).disposed(by: disposeBag)
    }
    
    private func configureBackgroundContainerView() {
        backgroundContainerView.clipsToBounds = true
        backgroundContainerView.layer.cornerRadius = 10
        backgroundContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private func configureSearchTextField() {
        pokemonSearchTextField.layer.cornerRadius = 10
        pokemonSearchTextField.layer.masksToBounds = true
        pokemonSearchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TypePokemonColor")!]
        )
        
        pokemonSearchTextField.delegate = self
        pokemonSearchTextField.rx.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                self.viewModel.searchPokemons(query: value)
                let onSearch = !(value?.isEmpty == true)
                self.pokemonListCollectionView.refreshControl = onSearch ? nil : self.refreshControl
            })
            .disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        self.pokemonListCollectionView.register(UINib(nibName: "PokemonListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PokemonListCollectionViewCell")
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        self.pokemonListCollectionView.refreshControl = refreshControl
        self.pokemonListCollectionView.refreshControl?.beginRefreshing()
        self.pokemonListCollectionView.dataSource = self
        self.pokemonListCollectionView.delegate = self
    }
    
    // MARK: - Action
    @objc
    private func refreshData() {
        self.viewModel.refresh()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pokemonsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonListCollectionViewCell", for: indexPath) as? PokemonListCollectionViewCell else { return UICollectionViewCell() }
        let pokemon = viewModel.pokemon(at: indexPath.row)
        cell.configureContentDashboard(pokemon: pokemon)
        viewModel.loadNextPage(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailPokemonViewController()
        let detailPokemonViewModel = DetailPokemonViewModel(detailUseCase: Injection().provideDetailUeCase(), pokemon: viewModel.pokemon(at: indexPath.row))
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

// MARK: - UITextFieldDelegate
extension DashboardViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
