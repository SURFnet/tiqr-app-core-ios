import UIKit

class MainCoordinator: CoordinatorType {    
    
    weak var parent: CoordinatorType?
    
    var children: [CoordinatorType] = []
    weak var homeNavigationController: UINavigationController!
    
    init(homeNavigationController: UINavigationController) {
        self.homeNavigationController = homeNavigationController
        
    }
    
    func start() {
        let onboardingNavigationController = UINavigationController()
        onboardingNavigationController.modalTransitionStyle = .flipHorizontal
        onboardingNavigationController.isModalInPresentation = true
        
        let onboardingCoordinator = OnboardingCoordinator(navigationController: onboardingNavigationController)
        onboardingCoordinator.parent = self
        children.append(onboardingCoordinator)
        
        homeNavigationController.present(onboardingNavigationController, animated: false)
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
        editPersonalInfoViewcontroller.coordinator = personalInfoCoordinator
        children.append(personalInfoCoordinator)
         
        homeNavigationController.present(personalInfoNavigationController, animated: true)
        personalInfoCoordinator.start()
    }
    
    //MARK: - start scan screen
    @objc
    func showScanScreen() {
        let scanViewcontroller = ScanViewController(viewModel: ScanViewModel())
        scanViewcontroller.coordinator = self
        let logo = UIImageView(image: UIImage.eduIDLogo)
        logo.width(92)
        logo.height(36)
        scanViewcontroller.navigationItem.titleView = logo
        scanViewcontroller.navigationItem.hidesBackButton = true
        scanViewcontroller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: self, action: #selector(dismissScanScreen))
        
        scanViewcontroller.navigationItem.leftBarButtonItem?.image = scanViewcontroller.navigationItem.leftBarButtonItem?.image?.withRenderingMode(.alwaysTemplate)
        
        let scanNavigationController = UINavigationController(rootViewController: scanViewcontroller)
        scanNavigationController.navigationBar.tintColor = .white
        scanNavigationController.setNavigationBarHidden(false, animated: true)
        homeNavigationController.present(scanNavigationController, animated: true)
    }
    
    //MARK: - dismiss scan
    @objc
    func dismissScanScreen() {
        homeNavigationController.presentedViewController?.dismiss(animated: true)
    }
}
