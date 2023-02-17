import UIKit

class CreateEduIDBaseViewController: BaseViewController {
    
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
        (delegate as? CreateEduIDViewControllerDelegate)?.createEduIDViewControllerShowNextScreen(viewController: self)
    }
    
    @objc
    func showScanScreen() {
        (delegate as? OnBoardingViewControllerDelegate)?.createEduIDViewControllerShowScanScreen(viewController: self)
    }

}

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}
