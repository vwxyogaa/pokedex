//
//  UIImageViewExtension.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - kingfisher load image
extension UIImageView {
    func loadImage(uri: String?, placeholder: UIImage? = nil) {
        guard let uri = uri, let uriImage = URL(string: uri) else { return }
        self.kf.setImage(with: uriImage, placeholder: placeholder)
    }
}
