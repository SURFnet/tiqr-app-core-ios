import UIKit

final class OnboardingCoordinator: OnboardingCoordinatorType, OnBoardingNavigationDelegate, ScanMainNavigationDelegate {
    
    weak var navigationController: UINavigationController!
    weak var delegate: OnBoardingMainNavigationDelegate?
    
    var children: [CoordinatorType] = []
    
    var currentScreenType: ScreenType = .landingScreen
    
    func start(presentOn viewController: UIViewController) {
        
        let landingScreen = OnBoardingLandingPageViewController()
        landingScreen.screenType = .landingScreen
        landingScreen.delegate = self
        
        let navigationController = UINavigationController(rootViewController: landingScreen)
        navigationController.modalTransitionStyle = .flipHorizontal
        
        self.navigationController = navigationController
        
//        viewController.present(self.navigationController, animated: false)
    }
    
    //MARK: - start scan screen
    func showScanScreen() {
        let scanCoordinator = ScanCoordinator()
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start(presentedOn: navigationController)
    }
    
    func dismissScanScreen() {
        navigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
    
    
    //MARK: - show next screen
    func showNextScreen() {
        if currentScreenType == .addInstitutionScreen {
            delegate?.dismissOnBoarding()
            return
        }
        
        guard let nextViewController = ScreenType(rawValue: currentScreenType.rawValue + 1)?.viewController() else { return }
        (nextViewController as? OnBoardingBaseViewController)?.delegate = self
        (nextViewController as? EnterPersonalInfoViewController)?.delegate = self
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
