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
    case createPincodefirstEntryScreen
    case createPincodeSecondEntryScreen
    case firstTimeDialogScreen
    case addInstitutionScreen
    case biometricApprovalScreen
    case eduIDCreatedScreen
    
    // scan screens
    case scanScreen
    case verifyLoginScreen
    
    // personal info screens
    case personalInfoLandingScreen
    
    // security screens
    case securityLandingScreen
    case securityEnterEmailScreen
    case securityChangePasswordScreen
    
    // activity screens
    case activityLandingScreen
    
    case confirmScreen
    case pincodeScreen
    
    case none
    
    func nextCreateEduIDScreen() -> ScreenType {
        switch self {
        case .landingScreen:
            return .explanationScreen
        case .explanationScreen:
            return .enterInfoScreen
        case .enterInfoScreen:
            return .checkMailScreen
        case .checkMailScreen:
            return .eduIDCreatedScreen
        case .eduIDCreatedScreen:
            return .createPincodefirstEntryScreen
        case .createPincodefirstEntryScreen:
            return .createPincodeSecondEntryScreen
        case .createPincodeSecondEntryScreen:
            return .biometricApprovalScreen
        case .biometricApprovalScreen:
            return .enterPhoneScreen
        case .enterPhoneScreen:
            return .pinChallengeScreen
        case .pinChallengeScreen:
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
            return CreateEduIDLandingPageViewController()
        case .explanationScreen:
            return CreateEduIDExplanationViewController()
        case .enterInfoScreen:
            return CreateEduIDEnterPersonalInfoViewController(viewModel: EnterPersonalInfoViewModel())
        case .checkMailScreen:
            return CheckEmailViewController()
        case .enterPhoneScreen:
            return CreateEduIDEnterPhoneNumberViewController()
        case .pinChallengeScreen:
            return CreateEduIDEnterPinViewController(viewModel: PinViewModel(), isSecure: false)
        case .welcomeScreen:
            return CreateEduIDWelcomeViewController()
        case .addInstitutionScreen:
            return CreateEduIDAddInstitutionViewController()
        case .homeScreen:
            return HomeViewController()
        case .scanScreen:
            return ScanViewController(viewModel: ScanViewModel())
        case .personalInfoLandingScreen:
            return PersonalInfoViewController()
        case .firstTimeDialogScreen:
            return CreateEduIDFirstTimeDialogViewController()
        case .securityLandingScreen:
            return SecurityLandingViewController()
        case .createPincodefirstEntryScreen:
            return CreatePincodeFirstEntryViewController(viewModel: CreatePincodeAndBiometricAccessViewModel())
        case.createPincodeSecondEntryScreen:
            return CreatePincodeSecondEntryViewController(viewModel: CreatePincodeAndBiometricAccessViewModel())
        case .eduIDCreatedScreen:
            return CreateEduIDCreatedViewController()
        default:
            return nil
        }
    }
    
    func configureNavigationItem(item: UINavigationItem, target: Any? = nil, action: Selector? = nil) {
        switch self {
            // logo and cross to dismiss
        case .personalInfoLandingScreen, .securityLandingScreen, .activityLandingScreen:
            addLogoTo(item: item)
            item.hidesBackButton = true
            item.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: action)
            item.rightBarButtonItem?.tintColor = .backgroundColor
        
            // logo and white back arrow
        case .scanScreen:
            addLogoTo(item: item)
            item.hidesBackButton = true
            item.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: action)
            item.rightBarButtonItem?.tintColor = .white
            
        case .homeScreen:
            item.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: target, action: action)
            item.rightBarButtonItem = UIBarButtonItem(title: "Log off", style: .plain, target: target, action: action)
            
            // just logo
        case .confirmScreen, .verifyLoginScreen, .createPincodefirstEntryScreen, .createPincodeSecondEntryScreen, .biometricApprovalScreen, .firstTimeDialogScreen:
            addLogoTo(item: item)
            item.hidesBackButton = true
        default:
            addLogoTo(item: item)
            item.hidesBackButton = true
            item.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: target, action: action)
            item.leftBarButtonItem?.tintColor = .backgroundColor
        }
    }
    
    func addLogoTo(item: UINavigationItem) {
        let logo = UIImageView(image: .eduIDLogo)
        logo.width(92)
        logo.height(36)
        item.titleView = logo
    }
}
