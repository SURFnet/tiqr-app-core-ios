import UIKit

@objc
enum ScreenType: Int, CaseIterable {
    case landingScreen
    case createScreen
    case enterInfoScreen
    case checkMailScreen
    case enterPhoneScreen
    case pinChallengeScreen
    case welcomeScreen
    case addInstitutionScreen
    case accountCreatedScreen
    case none
    
    //MARK: - get the next viewcontroller in the flow and guard against out of bounds index
    func nextViewController(current: ScreenType) -> UIViewController? {
        guard current.rawValue != ScreenType.allCases.count - 2 else { return nil }
        
        let nextIndex = (ScreenType.allCases.firstIndex(of: current) ?? 0) + 1
        if let nextViewController = ScreenType.allCases[nextIndex].viewController() as? EduIDBaseViewController {
            nextViewController.screenType = ScreenType(rawValue: nextIndex) ?? .none
            return nextViewController
        }
        return nil
    }
    
    func viewController() -> UIViewController? {
        switch self {
        case .landingScreen:
            return LandingPageViewController()
        case .createScreen:
            return CreateEduIDLandingPageViewController()
        case .enterInfoScreen:
            return EnterPersonalInfoViewController()
        case .checkMailScreen:
            return CheckEmailViewController()
        case .enterPhoneScreen:
            return EnterPhoneNumberViewController()
        case .pinChallengeScreen:
            return PinChallengeViewController()
        case .welcomeScreen:
            return WelcomeExplanationViewController()
        case .addInstitutionScreen:
            return ReviewViewController()
        case .accountCreatedScreen:
            return OnboardingSuccessViewController()
        case .none:
            return nil
        }
    }
}
