import UIKit

class MainCoordinator: CoordinatorType, HomeNavigationDelegate {
    
    weak var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    
    init(homeNavigationController: UINavigationController) {
        self.homeNavigationController = homeNavigationController
        
    }
    
    func start() {
//        let onboardingCoordinator = OnboardingCoordinator()
//        onboardingCoordinator.parent = self
//        children.append(onboardingCoordinator)
//        
//        onboardingCoordinator.start(presentOn: homeNavigationController)
    }
    
    func showPersonalInfoScreen() {
        let personalInfoCoordinator = PersonalInfoCoordinator()
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.parent = self
        
        personalInfoCoordinator.start(presentOn: homeNavigationController)
    }
    
    //MARK: - scan screen methods
    @objc
    func showScanScreen() {
        let scanCoordinator = ScanCoordinator()
        children.append(scanCoordinator)
        scanCoordinator.parent = self
        scanCoordinator.start(presentedOn: homeNavigationController)
    }
    
    @objc
    func dismissScanScreen() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
    }
    
    //MARK: security screen flow
    func showSecurityScreen() {
        let securityCoordinator = SecurityCoordinator()
        children.append(securityCoordinator)
        securityCoordinator.start(presentOn: homeNavigationController)
    }
    func showActivityScreen() {}

}
