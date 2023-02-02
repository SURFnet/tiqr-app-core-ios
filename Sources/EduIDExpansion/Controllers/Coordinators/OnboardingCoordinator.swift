import UIKit

final class OnboardingCoordinator: OnboardingCoordinatorType {
    
    weak var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    weak var navigationController: UINavigationController!
    
    var currentScreenType: ScreenType = .landingScreen
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let landingScreen = LandingPageViewController()
        landingScreen.coordinator = self
        landingScreen.screenType = .landingScreen
        
        let successScreen = HomeViewController()
        successScreen.coordinator = self
        navigationController.pushViewController(landingScreen, animated: false)
        
        // show navigation bar buttons if needed
//        showNavigationBarButtonsIfNeeded(screenType: .landingScreen)
    }
    
    //MARK: - start scan screen
    @objc
    func showScanScreen() {
        let scanViewcontroller = ScanViewController(viewModel: ScanViewModel())
        scanViewcontroller.coordinator = self
        scanViewcontroller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .arrowBack.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(goBack))
        navigationController.navigationBar.tintColor = .white
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(scanViewcontroller, animated: true)
        
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
