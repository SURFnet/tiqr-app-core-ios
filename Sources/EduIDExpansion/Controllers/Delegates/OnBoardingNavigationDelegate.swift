//
//  File.swift
//  
//
//  Created by Jairo Bambang Oetomo on 02/02/2023.
//

import Foundation

protocol OnBoardingNavigationDelegate: AnyObject {
    
    func goBack()
    func showNextScreen()
    func showScanScreen()
}
