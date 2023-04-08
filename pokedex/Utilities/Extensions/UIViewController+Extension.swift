//
//  UIViewControllerExtension.swift
//  pokedex
//
//  Created by Panji Yoga on 06/02/23.
//

import UIKit

// MARK: - Manage Loading
extension UIViewController {
    func manageLoadingActivity(isLoading: Bool) {
        if isLoading {
            showLoadingActivity()
        } else {
            hideLoadingActivity()
        }
    }
    
    func showLoadingActivity() {
        self.view.makeToastActivity(.center)
    }
    
    func hideLoadingActivity() {
        self.view.hideToastActivity()
    }
}

// MARK: - Get Image
extension UIViewController {
    func getUIImage(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage(systemName: "minus.circle.fill")!
    }
}
