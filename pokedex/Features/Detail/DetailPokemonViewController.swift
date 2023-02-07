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
    @IBOutlet weak var statsSegmentedController: CustomSegmentedControl!
    @IBOutlet weak var contentStatsView: UIView!
    @IBOutlet weak var catchButton: UIButton!
    
    private lazy var aboutViewController = AboutViewController()
    private lazy var baseStatsViewController = BaseStatsViewController()
    private lazy var movesViewController = MovesViewController()
    
    var pokemonDetail: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
        statsSegmentedController.backgroundColor = .secondaryColor
        statsSegmentedController.selectorViewColor = .primaryColor
        statsSegmentedController.selectorTextColor = .primaryColor
    }
    
    private func configureCatchButton() {
        catchButton.backgroundColor = .primaryColor
        catchButton.layer.cornerRadius = 10
    }
    
    private func configureData() {
        guard let number = pokemonDetail?.id else { return }
        self.numberPokemonLabel.text = "#\(number)"
        self.namePokemonLabel.text = pokemonDetail?.name?.localizedCapitalized
        let image = pokemonDetail?.sprites?.other?.officialArtwork?.frontDefault ?? ""
        if let url = URL(string: image) {
            self.imagePokemon.kf.setImage(with: url, placeholder: UIImage(named: "pokeball"))
        }
    }
    
    // MARK: - Action
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CustomSegmentedControlDelegate
extension DetailPokemonViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        removeChild()
        switch index {
        case 0:
            self.aboutViewController.pokemonDetail = pokemonDetail
            addChildVC(aboutViewController)
        case 1:
            if let pokemonStats = pokemonDetail?.stats {
                self.baseStatsViewController.pokemonStats = pokemonStats
            }
            addChildVC(baseStatsViewController)
        case 2:
            if let pokemonMoves = pokemonDetail?.moves {
                self.movesViewController.pokemonMoves = pokemonMoves
            }
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
        viewController.view.backgroundColor = .secondaryColor
        viewController.didMove(toParent: self)
    }
}
