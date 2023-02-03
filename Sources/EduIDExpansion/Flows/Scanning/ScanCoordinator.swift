import UIKit

class ScanCoordinator: CoordinatorType, ScanNavigationDelegate{

    weak var navigationController: UINavigationController?
    weak var delegate: ScanMainNavigationDelegate?
    
    func start(presentedOn viewController: UIViewController) {
        let scanViewcontroller = ScanViewController(viewModel: ScanViewModel())
        scanViewcontroller.delegate = self
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(scanViewcontroller, animated: false)
        
        viewController.present(navigationController, animated: true)
    }
    
    func dismiss() {
        delegate?.dismissScanScreen()
    }
}
