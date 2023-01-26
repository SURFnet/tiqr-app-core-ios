//
//  File.swift
//  
//
//  Created by Jairo Bambang Oetomo on 26/01/2023.
//

import UIKit

protocol CoordinatorType: AnyObject {
    
    var navigationController: UINavigationController { get set }
    var children: [CoordinatorType] { get set }
    func showNextScreen(currentType: ScreenType)
    func start()
}
