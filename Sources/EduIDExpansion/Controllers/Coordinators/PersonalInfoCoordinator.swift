import UIKit

class PersonalInfoCoordinator: CoordinatorType {
    
    var children: [CoordinatorType] = []
    
    var parent: CoordinatorType?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .backgroundColor
    }
    
    func start() {
        navigationController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissPersonalInfoFlow))
        let logo = UIImageView(image: UIImage.eduIDLogo)
        logo.width(92)
        logo.height(36)
        navigationController.navigationBar.topItem?.titleView = logo
    }
    
    @objc
    func dismissPersonalInfoFlow() {
        navigationController.dismiss(animated: true)
    }
    
    @objc
    func drillDown() {
        navigationController.pushViewController(EditPersonalInfoViewController(), animated: true)
        navigationController.viewControllers.last?.navigationItem.hidesBackButton = true
        navigationController.viewControllers.last?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .arrowBack, style: .plain, target: self, action: #selector(goBack))
        navigationController.navigationBar.tintColor = .backgroundColor
        let logo = UIImageView(image: .eduIDLogo)
        logo.width(92)
        logo.height(36)
        navigationController.viewControllers.last?.navigationItem.titleView = logo
    }
    
    @objc
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
