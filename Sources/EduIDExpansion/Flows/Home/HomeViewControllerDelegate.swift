import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    
    func homeViewControllerShowPersonalInfoScreen(sender: AnyObject)
    func homeViewControllerShowSecurityScreen(sender: AnyObject)
    func homeViewControllerShowActivityScreen(sender: AnyObject)
    func homeViewControllerShowScanScreen(sender: AnyObject)
}
