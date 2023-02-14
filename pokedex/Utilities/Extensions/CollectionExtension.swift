//
//  CollectionExtension.swift
//  pokedex
//
//  Created by yxgg on 03/02/23.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
