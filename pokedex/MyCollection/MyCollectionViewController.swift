//
//  MyCollectionViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class MyCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "My Collection"
    }
}
