import UIKit

protocol OnBoardingViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func goBack(viewController: UIViewController)
    func onBoardingViewControllerShowNextScreen(viewController: UIViewController)
    func onBoardingViewControllerShowScanScreen(viewController: UIViewController)
}
