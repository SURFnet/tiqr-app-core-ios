import Foundation

protocol OnboardingCoordinatorType: CoordinatorType {
    func showNextScreen(currentScreen: ScreenType)
    func goBack()
}
