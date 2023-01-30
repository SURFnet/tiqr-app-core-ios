import UIKit



class MainCoordinator: CoordinatorType {
    
    var children: [CoordinatorType] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: self.navigationController)
        children.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
}
