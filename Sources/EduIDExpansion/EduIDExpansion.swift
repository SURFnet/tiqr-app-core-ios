import UIKit

public final class EduIDExpansion: NSObject {
    
    public static let shared = EduIDExpansion()
    
    private var mainCoordinator: MainCoordinator!
    private override init() {
        super.init()
    }
    
    public func attachViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        mainCoordinator = MainCoordinator(homeNavigationController: homeNavigationController)
        homeViewController.delegate = mainCoordinator
        return homeNavigationController
    }
    
    public func run() {
        mainCoordinator.start()
    }
}
