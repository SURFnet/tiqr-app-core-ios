import UIKit

final class OnboardingCoordinator: CoordinatorType {
    
    weak var viewControllerToPresentOn: UIViewController?
    
    weak var navigationController: UINavigationController!
    weak var delegate: OnBoardingCoordinatorDelegate?
    
    var children: [CoordinatorType] = []
    
    // state variable to keep track of the current screen in the flow
    var currentScreenType: ScreenType = .landingScreen
    
    //MARK: - init
    required init(viewControllerToPresentOn: UIViewController?) {
        self.viewControllerToPresentOn = viewControllerToPresentOn
    }
    
    //MARK: - start
    func start() {
        
        let landingScreen = OnBoardingLandingPageViewController()
        landingScreen.screenType = .landingScreen
        landingScreen.delegate = self
        
        let navigationController = UINavigationController(rootViewController: landingScreen)
        navigationController.modalTransitionStyle = .flipHorizontal
        
        self.navigationController = navigationController
        
        // the next line is responsible for presenting the onboarding and is sometimes commented out for development purposes
//        viewControllerToPresentOn?.present(self.navigationController, animated: false)
    }
}

extension OnboardingCoordinator: ScanCoordinatorDelegate {
    
    //MARK: - start scan screen
    
    
    func scanCoordinatorDismissScanScreen(coordinator: CoordinatorType) {
        navigationController.presentedViewController?.dismiss(animated: true)
        children.removeAll { $0 is ScanCoordinator }
    }
}

extension OnboardingCoordinator: OnBoardingViewControllerDelegate {
    
    func onBoardingViewControllerShowScanScreen(viewController: UIViewController) {
        let scanCoordinator = ScanCoordinator(viewControllerToPresentOn: navigationController)
        scanCoordinator.delegate = self
        children.append(scanCoordinator)
        scanCoordinator.start()
    }
    
    //MARK: - show next screen
    func onBoardingViewControllerShowNextScreen(viewController: UIViewController) {
        if currentScreenType == .addInstitutionScreen {
            delegate?.onBoardingCoordinatorDismissOnBoarding(coordinator: self)
            return
        }
        
        guard let nextViewController = currentScreenType.nextOnBoardingScreen().viewController() else { return }
        (nextViewController as? OnBoardingBaseViewController)?.delegate = self
        (nextViewController as? OnBoardingEnterPersonalInfoViewController)?.delegate = self
        navigationController.pushViewController(nextViewController, animated: true)
        currentScreenType = ScreenType(rawValue: currentScreenType.rawValue + 1) ?? .none
    }
    
    
    //MARK: - back action
    @objc
    func goBack(viewController: UIViewController) {
        currentScreenType = ScreenType(rawValue: max(0, currentScreenType.rawValue - 1)) ?? .none
        navigationController.popViewController(animated: true)
    }
}

