import UIKit

final class ScanCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController?
    weak var delegate: ScanCoordinatorDelegate?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    //MARK: - start
    func start() {
        let scanViewcontroller = ScanViewController(viewModel: ScanViewModel())
        scanViewcontroller.delegate = self
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(scanViewcontroller, animated: false)
        
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
}
    
extension ScanCoordinator: ScanViewControllerDelegate {
        
    func scanViewControllerDismissScanFlow(viewController: UIViewController) {
        delegate?.scanCoordinatorDismissScanScreen(coordinator: self)
    }
}
