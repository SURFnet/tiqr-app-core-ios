import UIKit

class ActivityCoordinator: CoordinatorType {
    
    weak var navigationController: UINavigationController?
    weak var delegate: ActivityMainNavigationDelegate?
    
    func start(presentOn viewController: UIViewController) {
        let activityViewController = ActivityViewController()
        activityViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: activityViewController)
        self.navigationController = navigationController
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.isModalInPresentation = true
        
        viewController.present(navigationController, animated: true)
        
        
    }
}

extension ActivityCoordinator: ActivityNavigationDelegate {
    
    func activityViewControllerDismissActivityFlow(viewController: UIViewController) {
        delegate?.dismissActivityFlow(sender: self)
    }
}
