//
//  BaseViewModel.swift
//  pokedex
//
//  Created by Panji Yoga on 16/02/23.
//

import RxRelay
import RxCocoa

class BaseViewModel {
    let _isLoading = BehaviorRelay<Bool>(value: false)
    let _errorMessage = BehaviorRelay<String?>(value: nil)
    
    var isLoading: Driver<Bool> {
        return _isLoading.asDriver()
    }
    var errorMessage: Driver<String?> {
        return _errorMessage.asDriver()
    }
}
