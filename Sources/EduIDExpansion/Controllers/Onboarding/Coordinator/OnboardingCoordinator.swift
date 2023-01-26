import UIKit

final class OnboardingCoordinator: CoordinatorType {
    
    
    var children: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        let landingScreen = LandingPageViewController()
        landingScreen.coordinator = self
        landingScreen.screenType = .landingScreen
        navigationController.pushViewController(landingScreen, animated: false)
    }
    
    //MARK: - start scan screen
    func showScanScreen() {
        let scanViewcontroller = ScanViewController()
        scanViewcontroller.coordinator = self
        scanViewcontroller.navigationItem.leftBarButtonItem?.image = scanViewcontroller.navigationItem.leftBarButtonItem?.image?.withRenderingMode(.alwaysTemplate)
        navigationController.navigationBar.tintColor = .white
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(scanViewcontroller, animated: true)
    }
    
    //MARK: - show next screen
    func showNextScreen(currentType: ScreenType) {
        guard let nextViewController = currentType.nextViewController(current: currentType) else { return }
        
        (nextViewController as? EduIDBaseViewController)?.coordinator = self
        navigationController.pushViewController(nextViewController, animated: true)
    }
}
