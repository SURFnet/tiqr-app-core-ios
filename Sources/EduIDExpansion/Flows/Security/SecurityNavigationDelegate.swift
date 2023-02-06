import Foundation

protocol SecurityNavigationDelegate: AnyObject, NavigationDelegate {
    
    func goBack(sender: AnyObject)
    func enterVerifyEmailFlow(sender: AnyObject)
    func dismissSecurityFlow(sender: AnyObject)
    func verifyEmail(sender: AnyObject)
    func enterChangePasswordFlow(sender: AnyObject)
    func resetPassword(sender: AnyObject)
}
