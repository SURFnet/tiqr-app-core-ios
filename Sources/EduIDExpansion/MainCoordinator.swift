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
        let onboardingCoordinator = OnboardingCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(onboardingCoordinator)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start()
    }
    
    func showActivityScreen() {}
}

extension MainCoordinator: HomeViewControllerDelegate  {
    
    func homeViewControllerShowPersonalInfoScreen(sender: AnyObject) {
        let personalInfoCoordinator = PersonalInfoCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.delegate = self
        personalInfoCoordinator.start()
    }
    
    func homeViewControllerShowSecurityScreen(sender: AnyObject) {
        let securityCoordinator = SecurityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(securityCoordinator)
        securityCoordinator.delegate = self
        securityCoordinator.start()
    }
    
    func homeViewControllerShowActivityScreen(sender: AnyObject) {
        let activityCoordinator = ActivityCoordinator(viewControllerToPresentOn: homeNavigationController)
        children.append(activityCoordinator)
        activityCoordinator.delegate = self
        activityCoordinator.start()
    }
    
    func homeViewControllerShowScanScreen(sender: AnyObject) {
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
    
extension MainCoordinator: OnBoardingCoordinatorDelegate {
    
    //MARK: - onboarding delegate
    func onBoardingCoordinatorDismissOnBoarding(coordinator: CoordinatorType) {
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
