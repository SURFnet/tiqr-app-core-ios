//
//  BaseViewController.swift
//  
//
//  Created by Jairo Bambang Oetomo on 06/02/2023.
//

import UIKit

class BaseViewController: UIViewController, ScreenWithScreenType {
    
    //MARK: - screentype
    var screenType: ScreenType = .none

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        screenType.configureNavigationItem(item: self.navigationItem, target: self, action: #selector(goBack))
    }
    
    @objc
    func goBack() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
