import UIKit

class PersonalInfoCoordinator: CoordinatorType, PersonalInfoNavigationDelegate {
    
    weak var delegate: PersonalInfoMainNavigationDelegate?
    weak var navigationController: UINavigationController?
    
    func start(presentOn viewController: UIViewController) {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        let editPersonalInfoViewcontroller = EditPersonalInfoViewController()
        editPersonalInfoViewcontroller.delegate = self
        
        navigationController.modalTransitionStyle = .flipHorizontal
        navigationController.isModalInPresentation = true
        navigationController.pushViewController(editPersonalInfoViewcontroller, animated: false)
        
        viewController.present(navigationController, animated: true)
    }
    
    func dismiss(sender: AnyObject) {
        delegate?.dismissPersonalInfoFlow(sender: self)
    }
    
    @objc
    func enterItem() {
        //TODO: implement screens
    }
    
    @objc
    func goBack(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}
