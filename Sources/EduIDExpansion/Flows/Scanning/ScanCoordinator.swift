import UIKit

final class ScanCoordinator: NSObject, CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController?
    weak var delegate: ScanCoordinatorDelegate?
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    //MARK: - start
    func start() {
        let viewModel = ScanViewModel()
        let scanViewcontroller = ScanViewController(viewModel: viewModel)
        viewModel.delegate = scanViewcontroller
        scanViewcontroller.delegate = self
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.pushViewController(scanViewcontroller, animated: false)
        navigationController.transitioningDelegate = self
        navigationController.modalPresentationStyle = .custom
        
        viewControllerToPresentOn?.present(navigationController, animated: true)
    }
}
    
extension ScanCoordinator: ScanViewControllerDelegate {
       
    func scanViewControllerDismissScanFlow(viewController: ScanViewController) {
        delegate?.scanCoordinatorDismissScanScreen(coordinator: self)
    }
    
    func promtUserWithVerifyScreen(viewController: ScanViewController, viewModel: ScanViewModel) {
        let verifyViewController = VerifyLoginViewController(viewModel: viewModel)
        verifyViewController.delegate = self
        navigationController?.pushViewController(verifyViewController, animated: true)
    }
}

extension ScanCoordinator: VerifyLoginViewControllerDelegate {
    func verifyLoginViewControllerLogin(viewController: VerifyLoginViewController, viewModel: ScanViewModel) {
        let confirmViewController = ConfirmViewController()
        confirmViewController.delegate = self
        navigationController?.pushViewController(confirmViewController, animated: true)
    }
}

extension ScanCoordinator: ConfirmViewControllerDelegate {
    
    func confirmViewControllerDismiss(viewController: ConfirmViewController) {
        navigationController?.dismiss(animated: true)
    }
}

extension ScanCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QRAnimatedTransition(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QRAnimatedTransition(presenting: false)
    }
}
