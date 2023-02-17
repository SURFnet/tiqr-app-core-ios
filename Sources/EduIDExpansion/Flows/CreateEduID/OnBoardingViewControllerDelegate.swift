import UIKit

protocol OnBoardingViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func goBack(viewController: UIViewController)
    func onBoardingViewControllerShowNextScreen(viewController: UIViewController)
    func onBoardingViewControllerShowScanScreen(viewController: UIViewController)
    func onBoardingViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeViewModel)
    func onBoardingViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeViewModel)
    func onBoardingViewControllerRedoCreatePin(viewController: CreatePincodeSecondEntryViewController)
    
}
