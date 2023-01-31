import UIKit

class MainCoordinator: CoordinatorType {
    
    var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: self.navigationController)
        onboardingCoordinator.parent = self
        children.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showPersonalInfo() {
        let editPersonalInfoViewcontroller = EditPersonalInfoViewController()
        editPersonalInfoViewcontroller.screenType = .personalInfoScreen
        editPersonalInfoViewcontroller.modalTransitionStyle = .flipHorizontal
        
        let personalInfoNavigationController = UINavigationController(rootViewController: editPersonalInfoViewcontroller)
        personalInfoNavigationController.modalTransitionStyle = .flipHorizontal
        personalInfoNavigationController.isModalInPresentation = true
        
        let personalInfoCoordinator = PersonalInfoCoordinator(navigationController: personalInfoNavigationController)
        children.append(personalInfoCoordinator)
         
        navigationController.present(personalInfoNavigationController, animated: true)
        personalInfoCoordinator.start()
    }
    
    func showNavigationBarButtonsIfNeeded(screenType: ScreenType) {
        // show scanbutton if needed
        if screenType.showScanButtonInNavigationBar {
            navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(showScanScreen))
        } else {
            navigationController.viewControllers.last?.navigationItem.hidesBackButton = true
            navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: self, action: #selector(dismissScanScreen))
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
    
    //MARK: - back action
    @objc
    func dismissScanScreen() {
        navigationController.popViewController(animated: true)
        
        // show navigation bar buttons if needed
        navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(showScanScreen))
        
    }
}
