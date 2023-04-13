import UIKit

class MainCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    var protectionViewLayer: UIView?
    private let biometricService = BiometricService()
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        self.homeNavigationController = homeNavigationController
        homeViewController.delegate = self
    }
    
    func start(option: OnboardingFlowType) {
        if option == .newUser {
            let onboardingCoordinator = CreateEduIDCoordinator(viewControllerToPresentOn: homeNavigationController)
            children.append(onboardingCoordinator)
            onboardingCoordinator.delegate = self
            onboardingCoordinator.start()
        }
        createProtectionView()
        homeNavigationController.setNavigationBarHidden(true, animated: false)
        biometricService.useOnDeviceBiometricFeature { [weak self] success, _ in
            guard let self else { return }
            if success {
                self.homeNavigationController.setNavigationBarHidden(false, animated: true)
                self.removeProtectionView()
            }
        }
    }
    
    func showActivityScreen() {}
}

extension MainCoordinator: HomeViewControllerDelegate  {
    
    func homeViewControllerShowPersonalInfoScreen(viewController: HomeViewController) {
        let personalInfoCoordinator = PersonalInfoCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.delegate = self
        personalInfoCoordinator.start()
    }
    
    func homeViewControllerShowSecurityScreen(viewController: HomeViewController) {
        let securityCoordinator = SecurityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(securityCoordinator)
        securityCoordinator.delegate = self
        securityCoordinator.start()
    }
    
    func homeViewControllerShowActivityScreen(viewController: HomeViewController) {
        let activityCoordinator = ActivityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(activityCoordinator)
        activityCoordinator.delegate = self
        activityCoordinator.start()
    }
    
    func homeViewControllerShowScanScreen(viewController: HomeViewController) {
        let scanCoordinator = ScanCoordinator(viewControllerToPresentOn: homeNavigationController)
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start()
    }
}

//MARK: - personal info methods
extension MainCoordinator: PersonalInfoCoordinatorDelegate {
    
    func personalInfoCoordinatorDismissPersonalInfoFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

    
//MARK: - scan screen methods
extension MainCoordinator: ScanCoordinatorDelegate {
    
    func scanCoordinatorJumpToCreatePincodeScreen(coordinator: ScanCoordinator, viewModel: ScanViewModel) {
        // not implemented
    }
    
    func scanCoordinatorDismissScanScreen(coordinator: ScanCoordinator) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

//MARK: - security screen flow
extension MainCoordinator: SecurityCoordinatorDelegate {

    func securityCoordinatorDismissSecurityFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}
 
//MARK: - onboarding delegate
extension MainCoordinator: CreateEduIDCoordinatorDelegate {
    
    func createEduIDCoordinatorDismissOnBoarding(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

//MARK: - activity flow methods
extension MainCoordinator: ActivityCoordinatorDelegate {
    func activityCoordinatorDismissActivityFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

//MARK: - Add protection layer when launching app
extension MainCoordinator {
    
    func createProtectionView() {
        guard let view = mainView() else { return }
        self.protectionViewLayer = UIView(frame: view.bounds)
        protectionViewLayer?.backgroundColor = .clear
        view.addSubview(protectionViewLayer!)
        protectionViewLayer?.center = view.center
        let blurLayer = UIVisualEffectView(frame: view.bounds)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        blurLayer.effect = blurEffect
        protectionViewLayer?.addSubview(blurLayer)
        blurLayer.center = protectionViewLayer!.center
    }
    
    func removeProtectionView() {
        guard mainView() != nil, protectionViewLayer != nil else { return }
        homeNavigationController.setNavigationBarHidden(false, animated: true)
        protectionViewLayer?.removeFromSuperview()
    }
    
    private func mainView() -> UIView? {
        guard let navController = homeNavigationController else { return nil}
        guard let firstController = navController.viewControllers.first else { return nil }
        return firstController.view
    }
    
}
