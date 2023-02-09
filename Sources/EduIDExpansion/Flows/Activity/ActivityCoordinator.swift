import UIKit

final class ActivityCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    weak var navigationController: UINavigationController?
    weak var delegate: ActivityCoordinatorDelegate?
    
    //MARK: start
    func start() {
        let activityViewController = ActivityViewController()
        activityViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: activityViewController)
        self.navigationController = navigationController
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.isModalInPresentation = true
        
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
}

extension ActivityCoordinator: ActivityViewControllerDelegate {
    
    func activityViewControllerDismissActivityFlow(viewController: UIViewController) {
        delegate?.activityCoordinatorDismissActivityFlow(coordinator: self)
    }
}
