//
//  AppCoordinator.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class AppCoordinator {
    
    private let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        setupTabBarAppearance()
    }
    
    func start() {
        setupTabs()
    }
    
    private func setupTabBarAppearance() {
        // Tab bar görünümünü özelleştir
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupTabs() {
        // Home Tab
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Compatibility Tab
        let compatibilityViewModel = CompatibilityViewModel()
        let compatibilityViewController = CompatibilityViewController(viewModel: compatibilityViewModel)
        let compatibilityNavigationController = UINavigationController(rootViewController: compatibilityViewController)
        compatibilityNavigationController.tabBarItem = UITabBarItem(
            title: "Uyum",
            image: UIImage(systemName: "sparkles"),
            selectedImage: UIImage(systemName: "sparkles")
        )
        
        // Settings Tab
        let settingsViewController = SettingsViewController()
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationController.tabBarItem = UITabBarItem(
            title: "Ayarlar",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear")
        )
        
        // Tab bar controller'a view controller'ları ekle
        tabBarController.viewControllers = [
            homeNavigationController,
            compatibilityNavigationController,
            settingsNavigationController
        ]
    }
}

