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
    
    func goBack(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissSecurityFlow(sender: AnyObject) {
        delegate?.dismissSecurityFlow(sender: self)
    }
    
    //MARK: - verify email flow
    
    func verifyEmail(sender: AnyObject) {
        let checkEmailViewController = CheckEmailViewController()
        checkEmailViewController.navDelegate = self
        navigationController?.pushViewController(checkEmailViewController, animated: true)
    }
    
    func enterVerifyEmailFlow(sender: AnyObject) {
        let emailViewController = SecurityEnterEmailViewController()
        emailViewController.delegate = self
        navigationController?.pushViewController(emailViewController, animated: true)
    }
    
    //MARK: - change password flow
    
    func enterChangePasswordFlow(sender: AnyObject) {
        let changePasswordViewController = SecurityChangePasswordViewController(viewModel: ChangePasswordViewModel())
        changePasswordViewController.delegate = self
        navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    func resetPassword(sender: AnyObject) {
        let confirmViewController = AlertMessageViewController(textMessage: "Password changed succefully", buttonTitle: "Ok") { [weak self] in
            if let self = self {
                self.securityGotoRootViewController(sender: self.navigationController!)
            }
        }
        navigationController?.pushViewController(confirmViewController, animated: true)
    }
    
    func securityGotoRootViewController(sender: AnyObject) {
        navigationController?.popToRootViewController(animated: true)
    }
}

