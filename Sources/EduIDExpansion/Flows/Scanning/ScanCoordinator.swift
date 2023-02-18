import UIKit

final class ScanCoordinator: NSObject, CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController!
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
    
//MARK: methods from the scan screen
extension ScanCoordinator: ScanViewControllerDelegate {
       
    func scanViewControllerDismissScanFlow(viewController: ScanViewController) {
        delegate?.scanCoordinatorDismissScanScreen(coordinator: self)
    }
    
    func promtUserWithVerifyScreen(viewController: ScanViewController, viewModel: ScanViewModel) {
        let verifyViewController = VerifyScanResultViewController(viewModel: viewModel)
        verifyViewController.delegate = self
        navigationController.pushViewController(verifyViewController, animated: true)
    }
}

//MARK: - enroll a user using a qr code
extension ScanCoordinator: VerifyScanResultViewControllerDelegate {
    
    func verifyScanResultViewControllerEnroll(viewController: VerifyScanResultViewController, viewModel: ScanViewModel) {
        let pincodeFirstEntryViewController = CreatePincodeFirstEntryViewController(viewModel: CreatePincodeAndBiometricAccessViewModel(enrollmentChallenge: viewModel.challenge as? EnrollmentChallenge))
        pincodeFirstEntryViewController.delegate = self
        navigationController.pushViewController(pincodeFirstEntryViewController, animated: true)
    }
    
    func verifyScanResultViewControllerLogin(viewController: VerifyScanResultViewController, viewModel: ScanViewModel) {
        let confirmViewController = ConfirmViewController()
        confirmViewController.delegate = self
        navigationController.pushViewController(confirmViewController, animated: true)
    }
}

//MARK: - confirm login and dismiss flow
extension ScanCoordinator: ConfirmViewControllerDelegate {
    
    func confirmViewControllerDismiss(viewController: ConfirmViewController) {
        navigationController?.dismiss(animated: true)
    }
}

//MARK: transition setup
extension ScanCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QRAnimatedTransition(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return QRAnimatedTransition(presenting: false)
    }
}

//MARK: - delegate methods from create EduID
extension ScanCoordinator: CreateEduIDViewControllerDelegate {
    func goBack(viewController: UIViewController) {
        // not implemented
    }
    
    func createEduIDViewControllerShowNextScreen(viewController: UIViewController) {
        // not implemented
    }
    
    func createEduIDViewControllerShowScanScreen(viewController: UIViewController) {
        // not implemented
    }
    
    func createEduIDViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) {
        let createPincodeSecondEntryViewController = CreatePincodeSecondEntryViewController(viewModel: viewModel)
        createPincodeSecondEntryViewController.delegate = self
        navigationController.pushViewController(createPincodeSecondEntryViewController, animated: true)
    }
    
    func createEduIDViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) {
        let biometricViewController = CreateEduIDBiometricApprovalViewController(viewModel: viewModel)
        biometricViewController.delegate = self
        navigationController.pushViewController(biometricViewController, animated: true)
    }
    
    func createEduIDViewControllerRedoCreatePin(viewController: CreatePincodeSecondEntryViewController) {
        navigationController.popToViewController(navigationController.viewControllers.first { $0 is CreatePincodeFirstEntryViewController}!, animated: true)
        let alert = UIAlertController(title: "Oops, let's try again", message: "The entered PIN codes were not equal", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // no action
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.navigationController.present(alert, animated: true)
        })
    }
    
    
}
