import UIKit

final class OnboardingCoordinator: OnboardingCoordinatorType {
    
    var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    var navigationController: UINavigationController
    
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
        showNavigationBarButtonsIfNeeded(screenType: .landingScreen)
    }
    
    //MARK: - start scan screen
    @objc
    func showScanScreen() {
        let scanViewcontroller = ScanViewController(viewModel: ScanViewModel())
        scanViewcontroller.coordinator = self
        scanViewcontroller.navigationItem.leftBarButtonItem?.image = scanViewcontroller.navigationItem.leftBarButtonItem?.image?.withRenderingMode(.alwaysTemplate)
        navigationController.navigationBar.tintColor = .white
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(scanViewcontroller, animated: true)
        
        // show navigation bar buttons if needed
        showNavigationBarButtonsIfNeeded(screenType: .scanScreen)
    }
    
    //MARK: - show next screen
    func showNextScreen(currentScreen: ScreenType) {
        guard let nextViewController = currentScreen.nextViewController(current: currentScreen) else { return }
        
        if currentScreen == .addInstitutionScreen {
            
        }
        
        (nextViewController as? EduIDBaseViewController)?.coordinator = self
        navigationController.pushViewController(nextViewController, animated: true)
        
        // show navigation bar buttons if needed
        showNavigationBarButtonsIfNeeded(screenType: (navigationController.viewControllers.last as? EduIDBaseViewController)?.screenType ?? .none)
    }
    
    //MARK: - back action
    @objc
    func goBack() {
        navigationController.popViewController(animated: true)
        
        // show navigation bar buttons if needed
        showNavigationBarButtonsIfNeeded(screenType: (navigationController.viewControllers.last as? EduIDBaseViewController)?.screenType ?? .none)
        
    }
    
    //MARK: - show navigationbar buttons if needed
    func showNavigationBarButtonsIfNeeded(screenType: ScreenType) {
        // show scanbutton if needed
        if screenType.showScanButtonInNavigationBar {
            navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(showScanScreen))
        } else {
            navigationController.viewControllers.last?.navigationItem.hidesBackButton = true
            navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: self, action: #selector(goBack))
            navigationController.navigationBar.tintColor = screenType.bartintColor
        }
        
        // show logo in titleview if needed
        if screenType.showLogoInTitleView {
            //create the scan barbutton item
            let logo = UIImageView(image: UIImage.eduIDLogo)
            logo.width(92)
            logo.height(36)
            navigationController.viewControllers.last?.navigationItem.titleView = logo
        } else {
            navigationController.viewControllers.last?.navigationItem.titleView = nil
        }
    }
}
