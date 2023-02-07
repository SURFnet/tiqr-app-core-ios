import UIKit

class OnBoardingBaseViewController: BaseViewController {
    
    weak var delegate: NavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc
    override func goBack() {
        delegate?.goBack(sender: self)
    }
    
    @objc
    func showNextScreen() {
        (delegate as? OnBoardingNavigationDelegate)?.showNextScreen(sender: self)
    }
    
    @objc
    func showScanScreen() {
        (delegate as? OnBoardingNavigationDelegate)?.showScanScreen(sender: self)
    }

}

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}
