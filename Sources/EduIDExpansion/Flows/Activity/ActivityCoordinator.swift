import UIKit

class ActivityCoordinator: CoordinatorType {
    
    weak var navigationController: UINavigationController?
    
    func start(presentOn viewController: UIViewController) {
        let activityViewController = ActivityViewController()
        let navigationController = UINavigationController(rootViewController: activityViewController)
        self.navigationController = navigationController
        viewController.present(navigationController, animated: true)
    }
}
