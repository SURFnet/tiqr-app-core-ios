import UIKit

final class OnboardingCoordinator: OnboardingCoordinatorType {
    
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
}

extension OnboardingCoordinator: ScanMainNavigationDelegate {
    
    //MARK: - start scan screen
    
    
    func dismissScanScreen(sender: AnyObject) {
        navigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
}

extension OnboardingCoordinator: OnBoardingNavigationDelegate {
    
    func showScanScreen(sender: AnyObject) {
        let scanCoordinator = ScanCoordinator()
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start(presentedOn: navigationController)
    }
    
    //MARK: - show next screen
    func showNextScreen(sender: AnyObject) {
        if currentScreenType == .addInstitutionScreen {
            delegate?.dismissOnBoarding(sender: self)
            return
        }
        
        guard let nextViewController = currentScreenType.nextOnBoardingScreen().viewController() else { return }
        (nextViewController as? OnBoardingBaseViewController)?.delegate = self
        (nextViewController as? EnterPersonalInfoViewController)?.delegate = self
        navigationController.pushViewController(nextViewController, animated: true)
        currentScreenType = ScreenType(rawValue: currentScreenType.rawValue + 1) ?? .none
    }
    
    
    //MARK: - back action
    @objc
    func goBack(sender: AnyObject) {
        currentScreenType = ScreenType(rawValue: max(0, currentScreenType.rawValue - 1)) ?? .none
        navigationController.popViewController(animated: true)
    }
}

