import UIKit

protocol CreateEduIDViewControllerDelegate: AnyObject, NavigationDelegate {
    
    func goBack(viewController: UIViewController)
    func createEduIDViewControllerShowNextScreen(viewController: UIViewController)
    func createEduIDViewControllerShowScanScreen(viewController: UIViewController)
    func createEduIDViewControllerShowConfirmPincodeScreen(viewController: CreatePincodeFirstEntryViewController, viewModel: CreatePincodeViewModel)
    func createEduIDViewControllerShowBiometricUsageScreen(viewController: CreatePincodeSecondEntryViewController, viewModel: CreatePincodeViewModel)
    func createEduIDViewControllerRedoCreatePin(viewController: CreatePincodeSecondEntryViewController)
    
}
