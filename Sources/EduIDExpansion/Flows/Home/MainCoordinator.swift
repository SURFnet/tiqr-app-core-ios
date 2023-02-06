import UIKit

class MainCoordinator: CoordinatorType {
    
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    
    init(homeNavigationController: UINavigationController) {
        self.homeNavigationController = homeNavigationController
        
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator()
        children.append(onboardingCoordinator)
        onboardingCoordinator.delegate = self
        onboardingCoordinator.start(presentOn: homeNavigationController)
    }
    
    func showActivityScreen() {}
}

extension MainCoordinator: HomeNavigationDelegate  {
    
    func showPersonalInfoScreen(sender: AnyObject) {
        let personalInfoCoordinator = PersonalInfoCoordinator()
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.delegate = self
        personalInfoCoordinator.start(presentOn: homeNavigationController)
    }
    
    func showSecurityScreen(sender: AnyObject) {
        let securityCoordinator = SecurityCoordinator()
        children.append(securityCoordinator)
        securityCoordinator.delegate = self
        securityCoordinator.start(presentOn: homeNavigationController)
    }
    
    func showActivityScreen(sender: AnyObject) {
        
    }
    
    func showScanScreen(sender: AnyObject) {
        let scanCoordinator = ScanCoordinator()
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start(presentedOn: homeNavigationController)
    }
}

extension MainCoordinator: PersonalInfoMainNavigationDelegate {
    //MARK: - personal info methods
    
    func dismissPersonalInfoFlow(sender: AnyObject) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is PersonalInfoCoordinator }
    }
}

    
extension MainCoordinator: ScanMainNavigationDelegate {
    
    //MARK: - scan screen methods
    func dismissScanScreen(sender: AnyObject) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
}

extension MainCoordinator: SecurityMainNavigationDelegate {
    
    //MARK: security screen flow
    func dismissSecurityFlow(sender: AnyObject) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is SecurityCoordinator }
    }
}
    
extension MainCoordinator: OnBoardingMainNavigationDelegate {
    
    //MARK: - onboarding delegate
    func dismissOnBoarding(sender: AnyObject) {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is OnboardingCoordinator }
    }

}
