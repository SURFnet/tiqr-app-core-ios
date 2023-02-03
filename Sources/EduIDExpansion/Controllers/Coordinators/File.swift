import UIKit

class SecurityCoordinator: CoordinatorType, SecurityNavigationDelegate {
    
    var children: [CoordinatorType] = []
    
    var parent: CoordinatorType?
    
    weak var navigationController: UINavigationController?
    
    func start(presentOn viewController: UIViewController) {
        let securityLandingViewController = SecurityLandingViewController()
        securityLandingViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: securityLandingViewController)
        self.navigationController = navigationController
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.isModalInPresentation = true
        
        viewController.present(navigationController, animated: true)
    }
    
    func dismissSecurityFlow() {
        navigationController?.dismiss(animated: true)
    }
    
}

