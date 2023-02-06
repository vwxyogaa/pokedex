//
//  UIViewControllerExtension.swift
//  pokedex
//
//  Created by Panji Yoga on 06/02/23.
//

import Foundation
import UIKit

// MARK: - loading
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
