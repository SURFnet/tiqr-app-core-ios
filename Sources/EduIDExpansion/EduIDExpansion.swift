import UIKit

public final class EduIDExpansion: NSObject {
    
    public static let shared = EduIDExpansion()
    
    private var mainCoordinator: MainCoordinator!
    private override init() {
        super.init()
    }
    
    public func attachViewController() -> UIViewController {
        mainCoordinator = MainCoordinator()
        return mainCoordinator.homeNavigationController
    }
    
    public func run() {
        mainCoordinator.start()
    }
}
