import UIKit

protocol VerifyLoginViewControllerDelegate: AnyObject {
    
    func verifyLoginViewControllerLogin(viewController: VerifyLoginViewController, viewModel: ScanViewModel)
}
