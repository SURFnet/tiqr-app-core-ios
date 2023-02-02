import Foundation

protocol OnBoardingNavigationDelegate: AnyObject {
    
    func goBack()
    func showNextScreen()
    func showScanScreen()
}
