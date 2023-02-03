import UIKit

class MainCoordinator: CoordinatorType, HomeNavigationDelegate, OnBoardingMainNavigationDelegate, ScanMainNavigationDelegate, SecurityMainNavigationDelegate, PersonalInfoMainNavigationDelegate {
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    
    init(homeNavigationController: UINavigationController) {
        self.homeNavigationController = homeNavigationController
        
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator()
        children.append(onboardingCoordinator)
        onboardingCoordinator.delegate = self
//        onboardingCoordinator.start(presentOn: homeNavigationController)
    }
    
    //MARK: - personal info methods
    func showPersonalInfoScreen() {
        let personalInfoCoordinator = PersonalInfoCoordinator()
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.delegate = self
        personalInfoCoordinator.start(presentOn: homeNavigationController)
    }
    
    func dismissPersonalInfoFlow() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is PersonalInfoCoordinator }
    }
    
    //MARK: - scan screen methods
    func showScanScreen() {
        let scanCoordinator = ScanCoordinator()
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start(presentedOn: homeNavigationController)
    }
    
    func dismissScanScreen() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
    
    //MARK: security screen flow
    func showSecurityScreen() {
        let securityCoordinator = SecurityCoordinator()
        children.append(securityCoordinator)
        securityCoordinator.delegate = self
        securityCoordinator.start(presentOn: homeNavigationController)
    }
    
    func dismissSecurityFlow() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is SecurityCoordinator }
    }
    
    func showActivityScreen() {}
    
    //MARK: - onboarding delegate
    func dismissOnBoarding() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is OnboardingCoordinator }
    }

}
