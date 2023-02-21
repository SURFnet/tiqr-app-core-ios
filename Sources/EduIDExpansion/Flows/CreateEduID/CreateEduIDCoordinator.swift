import UIKit
import TiqrCoreObjC

final class CreateEduIDCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController!
    weak var delegate: CreateEduIDCoordinatorDelegate?
    
    var children: [CoordinatorType] = []
    
    // state variable to keep track of the current screen in the flow
    var currentScreenType: ScreenType = .landingScreen
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    //MARK: - start
    func start() {
        
        let landingScreen = CreateEduIDLandingPageViewController()
        landingScreen.screenType = .landingScreen
        landingScreen.delegate = self
        
        let navigationController = UINavigationController(rootViewController: landingScreen)
        navigationController.isModalInPresentation = true
        navigationController.modalTransitionStyle = .flipHorizontal
        
        self.navigationController = navigationController
        
        // the next line is responsible for presenting the onboarding and is sometimes commented out for development purposes
        viewControllerToPresentOn?.present(self.navigationController, animated: false)
    }
}

extension CreateEduIDCoordinator: ScanCoordinatorDelegate {
    
    func scanCoordinatorDismissScanScreen(coordinator: ScanCoordinator) {
        navigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
    
    func scanCoordinatorJumpToCreatePincodeScreen(coordinator: ScanCoordinator, viewModel: ScanViewModel) {
        guard let challenge = viewModel.challenge as? EnrollmentChallenge else { return }
        
        let pincodeFirstAttemptViewController = CreatePincodeFirstEntryViewController(viewModel: CreatePincodeAndBiometricAccessViewModel(enrollmentChallenge: challenge))
        pincodeFirstAttemptViewController.delegate = self
        navigationController.pushViewController(pincodeFirstAttemptViewController, animated: true)
    }
}

extension CreateEduIDCoordinator: CreateEduIDViewControllerDelegate {
    
    func createEduIDViewControllerShowScanScreen(viewController: UIViewController) {
        let scanCoordinator = ScanCoordinator(viewControllerToPresentOn: navigationController)
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start()
    }
    
    //MARK: - show next screen
    func createEduIDViewControllerShowNextScreen(viewController: UIViewController) {
        if currentScreenType == .addInstitutionScreen {
            delegate?.createEduIDCoordinatorDismissOnBoarding(coordinator: self)
            return
        }
        
        guard let nextViewController = currentScreenType.nextCreateEduIDScreen().viewController() else { return }
        // TODO: add sensible comment
        (nextViewController as? CreateEduIDBaseViewController)?.delegate = self
        (nextViewController as? CreateEduIDEnterPersonalInfoViewController)?.delegate = self
        navigationController.pushViewController(nextViewController, animated: true)
        currentScreenType = currentScreenType.nextCreateEduIDScreen()
    }
    
    func createEduIDViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) {
        let createPincodeSecondEntryViewController = CreatePincodeSecondEntryViewController(viewModel: viewModel)
        createPincodeSecondEntryViewController.delegate = self
        navigationController.pushViewController(createPincodeSecondEntryViewController, animated: true)
        currentScreenType = .createPincodeSecondEntryScreen
    }
    
    func createEduIDViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeAndBiometricAccessViewModel) {
        let biometricViewController = BiometricAccessApprovalViewController(viewModel: viewModel)
        biometricViewController.delegate = self
        biometricViewController.biometricApprovaldelegate = self
        navigationController.pushViewController(biometricViewController, animated: true)
        currentScreenType = .biometricApprovalScreen
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

    @objc
    func goBack(viewController: UIViewController) {
        currentScreenType = ScreenType(rawValue: max(0, currentScreenType.rawValue - 1)) ?? .none
        navigationController.popViewController(animated: true)
    }
}

extension CreateEduIDCoordinator: BiometricApprovalViewControllerDelegate {
    
    func biometricApprovalViewControllerContinueWithSucces(viewController: BiometricAccessApprovalViewController) {
        
    }
    
    func biometricApprovalViewControllerSkipBiometricAccess(viewController: BiometricAccessApprovalViewController) {
    
    }
}
