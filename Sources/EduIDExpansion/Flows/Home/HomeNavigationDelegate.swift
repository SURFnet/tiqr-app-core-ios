import UIKit

protocol HomeNavigationDelegate: AnyObject {
    
    func showPersonalInfoScreen(sender: AnyObject)
    func showSecurityScreen(sender: AnyObject)
    func showActivityScreen(sender: AnyObject)
    func showScanScreen(sender: AnyObject)
}
