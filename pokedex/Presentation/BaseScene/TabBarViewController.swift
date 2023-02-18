//
//  TabBarViewController.swift
//  pokedex
//
//  Created by Panji Yoga on 31/01/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeTabBar() -> TabBarViewController {
        self.viewControllers = [
            makeNavigation(viewController: createDashboardTab()),
            makeNavigation(viewController: createMyCollectionTab())
        ]
        return self
    }
    
    private func makeNavigation(viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.delegate = self
        navigation.navigationBar.prefersLargeTitles = false
        return navigation
    }
    
    private func createDashboardTab() -> UIViewController {
        let dashboardController = DashboardViewController()
        dashboardController.tabBarItem.title = "Dashboard"
        dashboardController.tabBarItem.image = UIImage(systemName: "house")
        dashboardController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        let dashboardViewModel = DashboardViewModel(dashboardUseCase: Injection().provideDashboardUseCase())
        dashboardController.viewModel = dashboardViewModel
        return dashboardController
    }
    
    private func createMyCollectionTab() -> UIViewController {
        let myCollectionController = MyCollectionViewController()
        myCollectionController.tabBarItem.title = "My Collection"
        myCollectionController.tabBarItem.image = UIImage(systemName: "bookmark")
        myCollectionController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        let myCollectionViewModel = MyCollectionViewModel(myCollectionUseCase: Injection().provideMyCollectionsUseCase())
        myCollectionController.viewModel = myCollectionViewModel
        return myCollectionController
    }
}

extension UIViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 14.0, *) {
            viewController.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            viewController.navigationItem.backButtonTitle = ""
        }
        viewController.navigationController?.navigationBar.tintColor = .white
    }
}
