import UIKit

protocol ScanViewControllerDelegate: AnyObject {
    
    func scanViewControllerDismissScanFlow(viewController: ScanViewController)
    func scanViewControllerPromtUserWithVerifyScreen(viewController: ScanViewController, viewModel: ScanViewModel)
    func scanViewControllerShowConfirmScreen(viewController: ScanViewController)
}
