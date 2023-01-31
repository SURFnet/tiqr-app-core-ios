import UIKit

class EduIDBaseViewController: UIViewController {
    
    var screenType: ScreenType = .none
    weak var coordinator: OnboardingCoordinatorType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
    }
    
    @objc
    private func backTapped() {
        coordinator?.goBack()
    }
    
    @objc
    func showNextScreen() {
        coordinator?.showNextScreen(currentScreen: screenType)
    }

}
