import UIKit

protocol CoordinatorType: AnyObject {
    
    var children: [CoordinatorType] { get set }
    var parent: CoordinatorType? { get set }
}
