import Foundation

protocol OnboardingCoordinatorType: CoordinatorType {
    func showNextScreen()
    func goBack()
}
