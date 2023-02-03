import Foundation

protocol OnBoardingNavigationDelegate: AnyObject, NavigationDelegate {
    
    func goBack()
    func showNextScreen()
    func showScanScreen()
}
