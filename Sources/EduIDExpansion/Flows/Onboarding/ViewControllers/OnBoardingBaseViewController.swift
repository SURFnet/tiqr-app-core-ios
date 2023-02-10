import UIKit

class OnBoardingBaseViewController: BaseViewController {
    
    weak var delegate: NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc
    override func goBack() {
        delegate?.goBack(viewController: self)
    }
    
    @objc
    func showNextScreen() {
        (delegate as? OnBoardingViewControllerDelegate)?.onBoardingViewControllerShowNextScreen(viewController: self)
    }
    
    @objc
    func showScanScreen() {
        (delegate as? OnBoardingViewControllerDelegate)?.onBoardingViewControllerShowScanScreen(viewController: self)
    }

}

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}
