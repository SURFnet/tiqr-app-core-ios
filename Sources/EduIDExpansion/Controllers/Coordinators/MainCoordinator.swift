import UIKit

class MainCoordinator: CoordinatorType {    
    
    weak var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    
    init(homeNavigationController: UINavigationController) {
        self.homeNavigationController = homeNavigationController
        
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator()
        onboardingCoordinator.parent = self
        children.append(onboardingCoordinator)
        
        onboardingCoordinator.start(presentOn: homeNavigationController)
    }
    
    func showPersonalInfo() {
        let personalInfoNavigationController = UINavigationController()
        let personalInfoCoordinator = PersonalInfoCoordinator(navigationController: personalInfoNavigationController)
        personalInfoCoordinator.parent = self
        
        children.append(personalInfoCoordinator)
        personalInfoCoordinator.start()
    }
    
    //MARK: - start scan screen
    @objc
    func showScanScreen() {
        let scanCoordinator = ScanCoordinator()
        children.append(scanCoordinator)
        scanCoordinator.parent = self
        scanCoordinator.start(presentedOn: homeNavigationController)
    }
    
    //MARK: - dismiss scan
    @objc
    func dismissScanScreen() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
    }
}
