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
    }
    
    @objc
    func dismissPersonalInfoFlow() {
        navigationController.dismiss(animated: true)
    }
    
    @objc
    func drillDown() {
        navigationController.pushViewController(UIViewController(), animated: true)
    }
}
