//
//  DashboardViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Pokedex"
    }
}
