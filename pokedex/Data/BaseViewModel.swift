//
//  BaseViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import Foundation
import RxRelay

class BaseViewModel {
    let _isLoading = BehaviorRelay<Bool>(value: false)
    let _errorMessage = BehaviorRelay<String?>(value: nil)
    
    var isLoading: Bool { return _isLoading.value }
    var errorMessage: String? { return _errorMessage.value }
}
