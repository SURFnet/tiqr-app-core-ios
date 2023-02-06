import Foundation

protocol OnboardingCoordinatorType: CoordinatorType {
    func showNextScreen(sender: AnyObject)
    func goBack(sender: AnyObject)
}
