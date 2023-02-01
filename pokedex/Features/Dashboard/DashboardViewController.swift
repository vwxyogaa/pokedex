//
//  DashboardViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var searchPokemonTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        configureNavigationBar()
        configureSearchPokemonTextField()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Pokedex"
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func configureSearchPokemonTextField() {
        self.searchPokemonTextField.layer.cornerRadius = 10
        self.searchPokemonTextField.layer.masksToBounds = true
        searchPokemonTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
    }
}
