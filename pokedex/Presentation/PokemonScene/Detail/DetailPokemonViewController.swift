//
//  DetailPokemonViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 03/02/23.
//

import UIKit
import Kingfisher
import Lottie

class DetailPokemonViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var numberPokemonLabel: UILabel!
    @IBOutlet weak var namePokemonLabel: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var statsBackgroundView: UIView!
    @IBOutlet weak var statsSegmentedController: CustomSegmentedControl!
    @IBOutlet weak var contentStatsView: UIView!
    @IBOutlet weak var catchButton: UIButton!
    @IBOutlet weak var containerPokeballAnimationView: UIView!
    @IBOutlet weak var pokeballAnimationView: LottieAnimationView!
    
    private lazy var aboutViewController = AboutViewController()
    private lazy var baseStatsViewController = BaseStatsViewController()
    private lazy var movesViewController = MovesViewController()
    
    var pokemonDetail: Pokemon?
    var viewModel: DetailPokemonViewModel!
    
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
    
    private func configureViews() {
        configureBackButton()
        configureStatsBackgroundView()
        configureStatsSegmentedController()
        configureCatchButton()
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
    
    private func configureStatsSegmentedController() {
        statsSegmentedController.delegate = self
        statsSegmentedController.setButtonTitles(buttonTitles: ["About", "Base Stats", "Moves"])
        statsSegmentedController.setIndex(index: 0)
        statsSegmentedController.backgroundColor = UIColor(named: "GrayColor")
        statsSegmentedController.selectorViewColor = UIColor(named: "BlueColor") ?? .lightBlueColor
        statsSegmentedController.selectorTextColor = UIColor(named: "BlueColor") ?? .lightBlueColor
        statsSegmentedController.textColor = UIColor(named: "TypePokemonColor") ?? .white
    }
    
    private func configureCatchButton() {
        catchButton.backgroundColor = UIColor(named: "BlueColor")
        catchButton.layer.cornerRadius = 10
        catchButton.addTarget(self, action: #selector(catchButtonClicked(_:)), for: .touchUpInside)
    }
    
    private func configureData(pokemon: Pokemon?) {
        guard let number = pokemon?.id else { return }
        self.numberPokemonLabel.text = "#\(number)"
        self.namePokemonLabel.text = (viewModel.nickname != nil) ? "\(pokemon?.name?.capitalized ?? "") (\(viewModel.nickname ?? ""))" : pokemon?.name?.capitalized
        if let imageUrl = pokemon?.sprites?.other?.officialArtwork?.frontDefault {
            self.imagePokemon.loadImage(uri: imageUrl, placeholder: getUIImage(named: "pokeball"))
        } else {
            self.imagePokemon.image = getUIImage(named: "pokeball")
        }
    }
    
    private func initObservers() {
        viewModel.pokemon.observe(on: self) { pokemon in
            self.configureData(pokemon: pokemon)
            self.aboutViewController.pokemonDetail = pokemon
            self.baseStatsViewController.pokemonStats = pokemon?.stats ?? []
            self.movesViewController.pokemonMoves = pokemon?.moves ?? []
        }
        
        viewModel.isCatched.observe(on: self) { isCatched in
            self.updateCatchButton(isCatched: isCatched)
            self.namePokemonLabel.text = (self.viewModel.nickname != nil) ? "\(self.viewModel.pokemon.value?.name?.capitalized ?? "") (\(self.viewModel.nickname ?? ""))" : self.viewModel.pokemon.value?.name?.capitalized
        }
    }
    
    private func dialogSuccessCatch() {
        let dialogMessage = UIAlertController(title: "", message: "Success to catch it!.\nPlease give a nickname", preferredStyle: .alert)
        dialogMessage.addTextField { textfield in
            textfield.placeholder = "Type nickname"
        }
        let done = UIAlertAction(title: "Done", style: .default) { _ in
            let nickname = dialogMessage.textFields?.first?.text ?? "-"
            self.viewModel.catchPokemon(nickname: nickname)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(done)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func dialogFailedCatch() {
        let dialogMessage = UIAlertController(title: "", message: "Failed to catch it.\nPlease try again!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func dialogRelease() {
        let dialogMessage = UIAlertController(title: "", message: "Are you sure you want to release this pokemon?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { _ in
            self.viewModel.releasedPokemon()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        dialogMessage.addAction(yes)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func updateCatchButton(isCatched: Bool) {
        if isCatched {
            catchButton.tag = 1
            catchButton.setTitle("Release", for: .normal)
            catchButton.setTitleColor(UIColor(named: "BlueColor"), for: .normal)
            catchButton.backgroundColor = UIColor(named: "GrayColor")
        } else {
            catchButton.tag = 0
            catchButton.setTitle("Catch", for: .normal)
            catchButton.setTitleColor(UIColor(named: "GrayColor"), for: .normal)
            catchButton.backgroundColor = UIColor(named: "BlueColor")
        }
        catchButton.layer.borderWidth = 1.5
        catchButton.layer.borderColor = UIColor(named: "BlueColor")?.cgColor
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func catchButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            let catchPokemon = Bool.random()
            catchButton.isEnabled = false
            containerPokeballAnimationView.isHidden = false
            pokeballAnimationView.play(fromProgress: 0, toProgress: 1, loopMode: .repeat(2)) { _ in
                self.catchButton.isEnabled = true
                self.containerPokeballAnimationView.isHidden = true
                catchPokemon ? self.dialogSuccessCatch() : self.dialogFailedCatch()
            }
        } else {
            self.dialogRelease()
        }
    }
}

// MARK: - CustomSegmentedControlDelegate
extension DetailPokemonViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        removeChild()
        switch index {
        case 0:
            addChildVC(aboutViewController)
        case 1:
            addChildVC(baseStatsViewController)
        case 2:
            addChildVC(movesViewController)
        default: break
        }
    }
    
    private func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    private func addChildVC(_ viewController: UIViewController?) {
        guard let viewController else { return }
        addChild(viewController)
        contentStatsView.addSubview(viewController.view)
        viewController.view.frame = contentStatsView.bounds
        viewController.view.backgroundColor = UIColor(named: "GrayColor")
        viewController.didMove(toParent: self)
    }
}
