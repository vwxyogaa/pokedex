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
        return navigation
    }
    
    private func createDashboardTab() -> UIViewController {
        let dashboardController = DashboardViewController(nibName: "DashboardViewController", bundle: nil)
        dashboardController.tabBarItem.title = "Dashboard"
        dashboardController.tabBarItem.image = UIImage(systemName: "house")
        dashboardController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        let dashboardViewModel = DashboardViewModel()
        dashboardController.viewModel = dashboardViewModel
        return dashboardController
    }
    
    private func createMyCollectionTab() -> UIViewController {
        let myCollectionController = MyCollectionViewController(nibName: "MyCollectionViewController", bundle: nil)
        myCollectionController.tabBarItem.title = "My Collection"
        myCollectionController.tabBarItem.image = UIImage(systemName: "bookmark")
        myCollectionController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        return myCollectionController
    }
}
