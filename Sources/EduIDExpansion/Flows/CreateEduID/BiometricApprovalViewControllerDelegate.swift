import UIKit

protocol BiometricApprovalViewControllerDelegate: AnyObject {
    
    func biometricApprovalViewControllerContinueWithSucces(viewController: BiometricApprovalViewController)
    func biometricApprovalViewControllerSkipBiometricAccess(viewController: BiometricApprovalViewController)
}
