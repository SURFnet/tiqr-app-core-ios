import UIKit

class OnBoardingBaseViewController: BaseViewController {
    
    weak var delegate: OnBoardingNavigationDelegate?
    
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
        delegate?.showNextScreen(sender: self)
    }
    
    @objc
    func showScanScreen() {
        delegate?.showScanScreen(sender: self)
    }

}

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}
