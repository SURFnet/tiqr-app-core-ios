import UIKit

protocol PersonalInfoNavigationDelegate: AnyObject, NavigationDelegate {
    
    func personalInfoViewControllerDismissPersonalInfoFlow(viewController: UIViewController)
    func goBack(sender: AnyObject)
}
