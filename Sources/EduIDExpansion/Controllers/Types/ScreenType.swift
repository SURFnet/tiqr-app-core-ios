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
    case firstTimeDialogScreen
    case addInstitutionScreen
    case homeScreen
    
    case scanScreen
    
    case personalInfoScreen
    
    case none
    
    
    func viewController() -> UIViewController? {
        switch self {
        case .landingScreen:
            return LandingPageViewController()
        case .explanationScreen:
            return ExplanationViewController()
        case .enterInfoScreen:
            return EnterPersonalInfoViewController(viewModel: EnterPersonalInfoViewModel())
        case .checkMailScreen:
            return CheckEmailViewController()
        case .enterPhoneScreen:
            return EnterPhoneNumberViewController()
        case .pinChallengeScreen:
            return EnterPinViewController(viewModel: EnterPinViewModel())
        case .welcomeScreen:
            return WelcomeViewController()
        case .addInstitutionScreen:
            return AddInstitutionViewController()
        case .homeScreen:
            return HomeViewController()
        case .scanScreen:
            return ScanViewController(viewModel: ScanViewModel())
        case .personalInfoScreen:
            return EditPersonalInfoViewController()
        case .firstTimeDialogScreen:
            return FirstTimeDialogViewController()
        case .none:
            return nil
        }
    }
    
    var showLogoInTitleView: Bool {
        switch self {
        case .landingScreen, .homeScreen:
            return false
        default:
            return true
        }
    }
    
    var showScanButtonInNavigationBar: Bool {
        switch self {
        case .landingScreen, .homeScreen:
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
    
    func configureNavigationItem(item: UINavigationItem, target: Any? = nil, action: Selector? = nil) {
        switch self {
        case .scanScreen:
            let logo = UIImageView(image: UIImage.eduIDLogo)
            logo.width(92)
            logo.height(36)
            item.titleView = logo
            item.hidesBackButton = true
            item.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: target, action: action)
            item.rightBarButtonItem?.tintColor = .white
        case .landingScreen:
            item.leftBarButtonItem = UIBarButtonItem(image: .qrLogo.withRenderingMode(.alwaysOriginal), style: .done, target: target, action: action)
        case .explanationScreen, .enterInfoScreen, .checkMailScreen, .enterPhoneScreen, .pinChallengeScreen, .welcomeScreen, .firstTimeDialogScreen, .addInstitutionScreen:
            let logo = UIImageView(image: UIImage.eduIDLogo)
            logo.width(92)
            logo.height(36)
            item.titleView = logo
            item.hidesBackButton = true
            item.leftBarButtonItem = UIBarButtonItem(image: UIImage.arrowBack, style: .plain, target: target, action: action)
            item.leftBarButtonItem?.tintColor = .backgroundColor
        default:
            break
        }
    }
}
