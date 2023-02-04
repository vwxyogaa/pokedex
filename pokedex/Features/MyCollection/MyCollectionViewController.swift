//
//  MyCollectionViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class MyCollectionViewController: UIViewController {
    @IBOutlet weak var backgroundContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
    }
    
    private func configureBackgroundContainerView() {
        backgroundContainerView.layer.cornerRadius = 10
        backgroundContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundContainerView.clipsToBounds = true
    }
}
