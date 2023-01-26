import UIKit

public final class EduIDExpansion: NSObject {
    
    public static let shared = EduIDExpansion()
    
    private var mainCoordinator: MainCoordinator!
    
    private override init() {
        super.init()
    }
    
    public func run() -> UINavigationController {
        let navigationController = UINavigationController()
        mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.start()

        return navigationController
    }
}
