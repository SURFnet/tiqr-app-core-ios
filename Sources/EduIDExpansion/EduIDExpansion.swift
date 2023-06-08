import UIKit
import OpenAPIClient

public final class EduIDExpansion: NSObject {
    
    public static let shared = EduIDExpansion()
    
    private var mainCoordinator: MainCoordinator!
    private override init() {
        super.init()
        OpenAPIClientAPI.requestBuilderFactory = BearerRequestBuilderFactory()
    }
    
    public func attachViewController() -> UIViewController {
        mainCoordinator = MainCoordinator(viewControllerToPresentOn: nil)
        return mainCoordinator.homeNavigationController
    }
    
    public func run(option: OnboardingFlowType) {
        mainCoordinator.start(option: option)
    }
}
