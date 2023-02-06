import UIKit

class SecurityCoordinator: CoordinatorType, SecurityNavigationDelegate {
    
    weak var delegate: SecurityMainNavigationDelegate?
    weak var navigationController: UINavigationController?
    
    func start(presentOn viewController: UIViewController) {
        let securityLandingViewController = SecurityLandingViewController()
        securityLandingViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: securityLandingViewController)
        self.navigationController = navigationController
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.isModalInPresentation = true
        
        viewController.present(navigationController, animated: true)
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissSecurityFlow() {
        delegate?.dismissSecurityFlow()
    }
    
    //MARK: - verify email flow
    
    func verifyEmail() {
        let checkEmailViewController = CheckEmailViewController()
        checkEmailViewController.navDelegate = self
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func enterVerifyEmailFlow() {
        let emailViewController = SecurityEnterEmailViewController()
        emailViewController.delegate = self
        navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    //MARK: - change password flow
    
    func enterChangePasswordFlow() {
        let changePasswordViewController = SecurityChangePasswordViewController()
        changePasswordViewController.delegate = self
        navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
}

