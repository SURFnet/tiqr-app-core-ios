import UIKit

class ScanCoordinator: CoordinatorType {
   
    var children: [CoordinatorType] = []
    var parent: CoordinatorType?
    
    weak var navigationController: UINavigationController?
    
    func start(presentedOn viewController: UIViewController) {
        let scanViewcontroller = ScanViewController(viewModel: ScanViewModel())
        scanViewcontroller.coordinator = self
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(scanViewcontroller, animated: false)
        
        viewController.present(navigationController, animated: false)
    }
    
    @objc
    func dismissScanScreen() {
        navigationController?.dismiss(animated: false)
    }
}
