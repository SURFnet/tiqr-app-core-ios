import UIKit

class MainCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
        
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        self.homeNavigationController = homeNavigationController
        homeViewController.delegate = self
    }
    
    func start() {
        let onboardingCoordinator = CreateEduIDCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(onboardingCoordinator)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
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

extension MainCoordinator: PersonalInfoCoordinatorDelegate {
    
    //MARK: - personal info methods
    func personalInfoCoordinatorDismissPersonalInfoFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

    
extension MainCoordinator: ScanCoordinatorDelegate {
    
    //MARK: - scan screen methods
    func scanCoordinatorDismissScanScreen(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

extension MainCoordinator: SecurityCoordinatorDelegate {
    
    //MARK: - security screen flow
    func securityCoordinatorDismissSecurityFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}
    
extension MainCoordinator: CreateEduIDCoordinatorDelegate {
    
    //MARK: - onboarding delegate
    func createEduIDCoordinatorDismissOnBoarding(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}

extension MainCoordinator: ActivityCoordinatorDelegate {
    
    //MARK: - activity flow methods
    func activityCoordinatorDismissActivityFlow(coordinator: CoordinatorType) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 === coordinator }
    }
}
