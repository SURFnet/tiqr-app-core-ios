import UIKit

public final class EduIDExpansion: NSObject {
    
    public static let shared = EduIDExpansion()
    
    private var mainCoordinator: MainCoordinator!
    private override init() {
        super.init()
    }
    
    public func attachViewController() -> UIViewController {
        let homeViewController = HomeViewController()
        let logo = UIImageView(image: UIImage.eduIDLogo)
        logo.width(92)
        logo.height(36)
        homeViewController.navigationItem.titleView = logo
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        mainCoordinator = MainCoordinator(homeNavigationController: homeNavigationController)
        homeViewController.delegate = mainCoordinator
        homeViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: mainCoordinator, action: #selector(MainCoordinator.showScanScreen))
        return homeNavigationController
    }
    
    public func run() {
        mainCoordinator.start()
    }
}
