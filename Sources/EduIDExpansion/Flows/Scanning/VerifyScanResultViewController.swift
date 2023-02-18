import UIKit
import TiqrCoreObjC
import TinyConstraints

class VerifyScanResultViewController: BaseViewController {
    
    let viewModel: ScanViewModel
    weak var delegate: VerifyScanResultViewControllerDelegate?

    //MARK: - init
    init(viewModel: ScanViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        screenType = .verifyLoginScreen
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem)
    }
    //MARK: - setupUI
    func setupUI() {
        //top poster label
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Request to login", primary: "Request to login")
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        let upperspace = UIView()
        
        // text in middle with organisation name
        let middlePosterParent = UIView()
        let middlePosterLabel = UILabel.requestLoginLabel(entityName: (viewModel.challenge as? EnrollmentChallenge)?.identityDisplayName ?? "", challengeType: viewModel.challengeType ?? .invalid)
        middlePosterParent.addSubview(middlePosterLabel)
        middlePosterLabel.edges(to: middlePosterParent)
        
        let lowerSpace = UIView()
        
        let cancelButton = EduIDButton(type: .ghost, buttonTitle: "Cancel")
        
        let primaryButton: EduIDButton
        
        switch viewModel.challengeType {
        case .authentication:
            primaryButton = EduIDButton(type: .primary, buttonTitle: "Log in")
        case .enrollment:
            primaryButton = EduIDButton(type: .primary, buttonTitle: "Sign in")
        default:
            primaryButton = EduIDButton(type: .primary, buttonTitle: "")
        }

        let animatedHStack = AnimatedHStackView(arrangedSubviews: [cancelButton, primaryButton])
        animatedHStack.spacing = 24
        
        // the stackView
        let stack = BasicStackView(arrangedSubviews: [posterParent, upperspace, middlePosterParent, lowerSpace, animatedHStack])
        view.addSubview(stack)
        
        //constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        upperspace.height(to: lowerSpace)
        animatedHStack.width(to: stack)
        primaryButton.width(to: cancelButton)
        
        // actions:
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        primaryButton.addTarget(self, action: #selector(primaryAction), for: .touchUpInside)
        
    }
    
    //MARK: - button actions
    @objc
    func cancelAction() {
        
    }
    
    @objc
    func primaryAction() {
        switch viewModel.challengeType {
        case .enrollment:
            delegate?.verifyScanResultViewControllerEnroll(viewController: self, viewModel: viewModel)
        case .authentication:
            delegate?.verifyScanResultViewControllerLogin(viewController: self, viewModel: viewModel)
        default:
            break
        }
    }

}
