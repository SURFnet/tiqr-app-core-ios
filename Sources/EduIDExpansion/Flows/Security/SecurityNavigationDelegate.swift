import Foundation

protocol SecurityNavigationDelegate: AnyObject, NavigationDelegate {
    
    func goBack()
    func enterVerifyEmailFlow()
    func dismissSecurityFlow()
    func verifyEmail()
    func enterChangePasswordFlow()
}
