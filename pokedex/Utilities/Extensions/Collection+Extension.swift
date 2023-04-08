//
//  CollectionExtension.swift
//  pokedex
//
//  Created by yxgg on 03/02/23.
//

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
