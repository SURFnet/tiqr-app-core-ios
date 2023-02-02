import UIKit

final class OnboardingCoordinator: OnboardingCoordinatorType {
    
    
    weak var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    weak var navigationController: UINavigationController!
    
    var currentScreenType: ScreenType = .landingScreen
    
    func start(presentOn viewController: UIViewController) {
        
        let landingScreen = LandingPageViewController()
        landingScreen.coordinator = self
        landingScreen.screenType = .landingScreen
        
        let navigationController = UINavigationController(rootViewController: landingScreen)
        navigationController.modalTransitionStyle = .flipHorizontal
        
        self.navigationController = navigationController
        
        viewController.present(self.navigationController, animated: false)
        
        // show navigation bar buttons if needed
//        showNavigationBarButtonsIfNeeded(screenType: .landingScreen)
    }
    
    //MARK: - start scan screen
    @objc
    func showScanScreen() {
        let scanCoordinator = ScanCoordinator()
        children.append(scanCoordinator)
        scanCoordinator.parent = self
        scanCoordinator.start(presentedOn: navigationController)
        
    }
    
    //MARK: - show next screen
    func showNextScreen() {
        if currentScreenType == .addInstitutionScreen {
            navigationController.dismiss(animated: true)
        }
        
        guard let nextViewController = ScreenType(rawValue: currentScreenType.rawValue + 1)?.viewController() else { return }
        (nextViewController as? EduIDBaseViewController)?.coordinator = self
        navigationController.pushViewController(nextViewController, animated: true)
        currentScreenType = ScreenType(rawValue: currentScreenType.rawValue + 1) ?? .none
    }
    
    //MARK: - back action
    @objc
    func goBack() {
        currentScreenType = ScreenType(rawValue: max(0, currentScreenType.rawValue - 1)) ?? .none
        navigationController.popViewController(animated: true)
    }
}
