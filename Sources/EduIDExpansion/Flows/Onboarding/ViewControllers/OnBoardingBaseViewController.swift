import UIKit

class OnBoardingBaseViewController: BaseViewController {
    
    weak var delegate: OnBoardingNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc
    func goBack() {
        delegate?.goBack()
    }
    
    @objc
    func showNextScreen() {
        delegate?.showNextScreen()
    }
    
    @objc
    func showScanScreen() {
        delegate?.showScanScreen()
    }

}

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}
