import UIKit

protocol ScanViewControllerDelegate: AnyObject {
    
    func scanViewControllerDismissScanFlow(viewController: ScanViewController)
    func promtUserWithVerifyScreen(viewController: ScanViewController)
}
