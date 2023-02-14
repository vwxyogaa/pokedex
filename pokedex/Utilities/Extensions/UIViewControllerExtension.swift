//
//  UIViewControllerExtension.swift
//  pokedex
//
//  Created by Panji Yoga on 06/02/23.
//

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

// MARK: - connection lost alert
extension UIViewController {
    func connectionLostMessage(title: String?, message: String?, completion: @escaping (UIAlertAction) -> Void) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "Try Again", style: .default, handler: completion)
        dialogMessage.addAction(tryAgain)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
