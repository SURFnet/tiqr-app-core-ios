import UIKit

class EduIDBaseViewController: UIViewController {
    
    weak var coordinator: CoordinatorType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
    }
    
    @objc
    private func backTapped() {
        (coordinator as? OnboardingCoordinator)?.goBack()
    }
    
    @objc
    func showNextScreen() {
        (coordinator as? OnboardingCoordinator)?.showNextScreen()
    }

}

protocol ScreenWithScreenType {
    var screenType: ScreenType { get set }
}
