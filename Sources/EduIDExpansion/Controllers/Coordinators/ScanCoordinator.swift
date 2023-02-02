import UIKit

class ScanCoordinator: CoordinatorType, ScanNavigationDelegate{

    var children: [CoordinatorType] = []
    var parent: CoordinatorType?
    
    weak var navigationController: UINavigationController?
    
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
        navigationController?.dismiss(animated: true)
    }
}
