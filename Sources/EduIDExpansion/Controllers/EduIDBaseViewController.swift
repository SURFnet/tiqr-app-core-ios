import UIKit

class EduIDBaseViewController: UIViewController {
    
    var screenType: ScreenType = .none
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
        (coordinator as? OnboardingCoordinator)?.showNextScreen(currentScreen: screenType)
    }

}
