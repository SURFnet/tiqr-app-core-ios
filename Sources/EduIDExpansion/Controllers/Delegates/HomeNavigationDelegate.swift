import Foundation

protocol HomeNavigationDelegate: AnyObject {
    
    func showPersonalInfoScreen()
    func showSecurityScreen()
    func showActivityScreen()
    func showScanScreen()
}
