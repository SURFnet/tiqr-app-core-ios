import UIKit

class PersonalInfoCoordinator: CoordinatorType, PersonalInfoNavigationDelegate {
    
    var children: [CoordinatorType] = []
    
    var parent: CoordinatorType?
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
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc
    func drillDown() {
//        navigationController?.pushViewController(EditPersonalInfoViewController(), animated: true)
//        navigationController.viewControllers.last?.navigationItem.hidesBackButton = true
//        navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .arrowBack, style: .plain, target: self, action: #selector(goBack))
//        navigationController.navigationBar.tintColor = .backgroundColor
//        let logo = UIImageView(image: .eduIDLogo)
//        logo.width(92)
//        logo.height(36)
//        navigationController.viewControllers.last?.navigationItem.titleView = logo
    }
    
    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
