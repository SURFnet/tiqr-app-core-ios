//
//  MainCoordinator.swift
//  
//
//  Created by Jairo Bambang Oetomo on 26/01/2023.
//

import UIKit



class MainCoordinator: CoordinatorType {
    
    var children: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardinCoordinator =  OnboardingCoordinator(navigationController: self.navigationController)
        children.append(onboardinCoordinator)
        onboardinCoordinator.start()
    }
    
    func showNextScreen(currentType: ScreenType) {
        
    }
}
