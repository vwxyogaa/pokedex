//
//  UIViewExtension.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation
import UIKit

// MARK: - get image
extension UIView {
    func getUIImage(named: String) -> UIImage {
        return UIImage(named: named) ?? UIImage(systemName: "minus.circle.fill")!
    }
}
