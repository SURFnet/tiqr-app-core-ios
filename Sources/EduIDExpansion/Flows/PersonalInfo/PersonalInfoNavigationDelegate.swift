import UIKit

protocol PersonalInfoNavigationDelegate: AnyObject, NavigationDelegate {
    
    func dismiss(sender: AnyObject)
    func goBack(sender: AnyObject)
}
