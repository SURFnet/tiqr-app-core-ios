import UIKit

@objc
enum ScreenType: Int, CaseIterable {
    
    // home screen
    case homeScreen
    
    // onboarding screens
    case landingScreen
    case explanationScreen
    case enterInfoScreen
    case checkMailScreen
    case enterPhoneScreen
    case pinChallengeScreen
    case welcomeScreen
    case firstTimeDialogScreen
    case addInstitutionScreen
    
    // scan screen
    case scanScreen
    
    // personal info screens
    case personalInfoLandingScreen
    
    // security screens
    case securityLandingScreen
    case securityEnterEmailScreen
    case securityChangePasswordScreen
    
    // activity screens
    case activityLandingScreen
    
    case none
    
    func nextOnBoardingScreen() -> ScreenType {
        switch self {
        case .landingScreen:
            return .explanationScreen
        case .explanationScreen:
            return .enterInfoScreen
        case .enterInfoScreen:
            return .checkMailScreen
        case .checkMailScreen:
            return .enterPhoneScreen
        case .enterPhoneScreen:
            return .pinChallengeScreen
        case .pinChallengeScreen:
            return .welcomeScreen
        case .welcomeScreen:
            return .firstTimeDialogScreen
        case .firstTimeDialogScreen:
            return .addInstitutionScreen
        default:
            return .none
        }
    }
    
    func viewController() -> UIViewController? {
        switch self {
        case .landingScreen:
            return OnBoardingLandingPageViewController()
        case .explanationScreen:
            return OnBoardingExplanationViewController()
        case .enterInfoScreen:
            return OnBoardingEnterPersonalInfoViewController(viewModel: EnterPersonalInfoViewModel())
        case .checkMailScreen:
            return CheckEmailViewController()
        case .enterPhoneScreen:
            return OnBoardingEnterPhoneNumberViewController()
        case .pinChallengeScreen:
            return OnBoardingEnterPinViewController(viewModel: EnterPinViewModel())
        case .welcomeScreen:
            return OnBoardingWelcomeViewController()
        case .addInstitutionScreen:
            return OnBoardingAddInstitutionViewController()
        case .homeScreen:
            return HomeViewController()
        case .scanScreen:
            return ScanViewController(viewModel: ScanViewModel())
        case .personalInfoLandingScreen:
            return PersonalInfoViewController()
        case .firstTimeDialogScreen:
            return OnBoardingFirstTimeDialogViewController()
        case .securityLandingScreen:
            return SecurityLandingViewController()
        default:
            return nil
        }
    }
    
    func configureNavigationItem(item: UINavigationItem, target: Any? = nil, action: Selector? = nil) {
        switch self {
        case .personalInfoLandingScreen, .securityLandingScreen, .activityLandingScreen:
            let logo = UIImageView(image: UIImage.eduIDLogo)
            logo.width(92)
            logo.height(36)
            item.titleView = logo
            item.hidesBackButton = true
            item.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: action)
            item.rightBarButtonItem?.tintColor = .backgroundColor
        case .scanScreen:
            let logo = UIImageView(image: UIImage.eduIDLogo)
            logo.width(92)
            logo.height(36)
            item.titleView = logo
            item.hidesBackButton = true
            item.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: action)
            item.rightBarButtonItem?.tintColor = .white
        case .homeScreen:
            item.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: target, action: action)
        default:
            let logo = UIImageView(image: UIImage.eduIDLogo)
            logo.width(92)
            logo.height(36)
            item.titleView = logo
            item.hidesBackButton = true
            item.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: target, action: action)
            item.leftBarButtonItem?.tintColor = .backgroundColor
        }
    }
}
