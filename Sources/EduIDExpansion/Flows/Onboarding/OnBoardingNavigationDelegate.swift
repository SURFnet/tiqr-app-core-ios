import UIKit

protocol OnBoardingNavigationDelegate: AnyObject, NavigationDelegate {
    
    func goBack(sender: AnyObject)
    func showNextScreen(sender: AnyObject)
    func showScanScreen(sender: AnyObject)
}
