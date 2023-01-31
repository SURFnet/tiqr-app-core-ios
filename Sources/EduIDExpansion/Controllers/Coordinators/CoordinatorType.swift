import UIKit

protocol CoordinatorType: AnyObject {
    
    var navigationController: UINavigationController { get set }
    var children: [CoordinatorType] { get set }
    func start()
}
