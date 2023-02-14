//
//  CofirmPincodeViewController.swift
//  
//
//  Created by Jairo Bambang Oetomo on 14/02/2023.
//

import UIKit

class ConfirmPincodeViewController: PincodeBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        verifyButton.buttonTitle = "Confirm"
        textLabel.text = "Enter your PINcode again"
        posterLabel.text = "Repeat your PINcode"
    }
}
