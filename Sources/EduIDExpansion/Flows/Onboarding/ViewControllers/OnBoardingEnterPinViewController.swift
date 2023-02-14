import UIKit
import TinyConstraints

class OnBoardingEnterPinViewController: PincodeBaseViewController {
    
    //MARK: - init
    override init(viewModel: EnterPinViewModel, isSecure: Bool) {
        super.init(viewModel: viewModel, isSecure: isSecure)
        
        screenType = .pinChallengeScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
