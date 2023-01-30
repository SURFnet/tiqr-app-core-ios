import UIKit

@objc
enum ScreenType: Int, CaseIterable {
    case landingScreen
    case explanationScreen
    case enterInfoScreen
    case checkMailScreen
    case enterPhoneScreen
    case pinChallengeScreen
    case welcomeScreen
    case addInstitutionScreen
    case onboardingSuccessScreen
    
    case scanScreen
    
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
        case .explanationScreen:
            return ExplanationViewController()
        case .enterInfoScreen:
            return EnterPersonalInfoViewController()
        case .checkMailScreen:
            return CheckEmailViewController()
        case .enterPhoneScreen:
            return EnterPhoneNumberViewController()
        case .pinChallengeScreen:
            return PinChallengeViewController()
        case .welcomeScreen:
            return WelcomeViewController()
        case .addInstitutionScreen:
            return AddInstitutionViewController()
        case .onboardingSuccessScreen:
            return successViewController()
        case .scanScreen:
            return ScanViewController()
        case .none:
            return nil
        }
    }
    
    var showLogoInTitleView: Bool {
        switch self {
        case .landingScreen, .onboardingSuccessScreen:
            return false
        default:
            return true
        }
    }
    
    var showScanButtonInNavigationBar: Bool {
        switch self {
        case .landingScreen, .onboardingSuccessScreen:
            return true
        default:
            return false
        }
    }
    
    var bartintColor: UIColor {
        switch self {
        case .scanScreen:
            return .white
        default:
            return .backgroundColor
        }
    }
}
