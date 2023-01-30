//
//  EduIDBaseViewController.swift
//  eduID
//
//  Created by Jairo Bambang Oetomo on 19/01/2023.
//

import UIKit

class EduIDBaseViewController: UIViewController {
    
    var screenType: ScreenType = .none
    weak var coordinator: CoordinatorType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
    }
    
    @objc
    private func backTapped() {
        coordinator?.goBack()
    }
    
    @objc
    func showNextScreen() {
        coordinator?.showNextScreen(currentScreen: screenType)
    }

}
