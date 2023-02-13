//
//  UIColorExtension.swift
//  pokedex
//
//  Created by Panji Yoga on 06/02/23.
//

import UIKit

// MARK: - convert rgb to hex
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

// MARK: - color assets
extension UIColor {
    /// #37A5C6 Dark Blue
    static var darkBlueColor: UIColor = UIColor(rgb: 0x37A5C6)
    /// #40717E Light Blue
    static var lightBlueColor: UIColor = UIColor(rgb: 0x40717E)
    /// #F0F2F6 Light Gray
    static var lightGrayColor: UIColor = UIColor(rgb: 0xF0F2F6)
    /// #393939 Dark Gray
    static var darkGrayColor: UIColor = UIColor(rgb: 0x393939)
}
