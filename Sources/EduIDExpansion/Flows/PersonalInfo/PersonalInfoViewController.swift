import UIKit
import TinyConstraints

class PersonalInfoViewController: UIViewController, ScreenWithScreenType {
   
    // - screen type
    var screenType: ScreenType = .personalInfoLandingScreen
    
    // - delegate
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    var viewModel: PersonalInfoViewModel
    
    //MARK: - init
    init(viewModel: PersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.dataAvailableCallback = { [weak self] model in
            self?.setupUI(model: model)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    //MARK: - setup UI
    func setupUI(model: PersonalInfoDataCallbackModel) {
        
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: NSLocalizedString(LocalizedKey.Profile.title, bundle: .module, comment: ""), size: 24, primary: NSLocalizedString(LocalizedKey.Profile.title, bundle: .module, comment: ""))
        
        // - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel.plainTextLabelPartlyBold(text: """
When you use eduID to login to other websites, some of your personal information will be shared. Some websites require that your personal information is validated by a third party.
""", partBold: "")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        let spaceView = UIView()
        
        // - the info controls
        let firstTitle = NSAttributedString(string: "About you", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let firstBodyText = NSMutableAttributedString(string: "\(model.name ?? "")\nprovided by \(model.nameProvidedBy ?? "")", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .backgroundColor, lineSpacing: 6))
        firstBodyText.setAttributeTo(part: "provided by \(model.nameProvidedBy ?? "")", attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .charcoalColor, lineSpacing: 6))
        let firstControl = ActionableControlWithBodyAndTitle(attributedTitle: firstTitle, attributedBodyText: firstBodyText, iconInBody: model.isNameProvidedByInstitution ? .shield.withRenderingMode(.alwaysOriginal) : UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        let secondTitle = NSAttributedString(string: NSLocalizedString(LocalizedKey.Profile.email, bundle: .module, comment: ""))
        let secondBodyText = NSMutableAttributedString(string: "\(model.userResponse.email ?? "")\nprovided by me", attributes: AttributedStringHelper.attributes(font: .sourceSansProSemiBold(size: 16), color: .backgroundColor, lineSpacing: 6))
        secondBodyText.setAttributeTo(part: "provided by me", attributes: AttributedStringHelper.attributes(font: .sourceSansProRegular(size: 12), color: .charcoalColor, lineSpacing: 6))
        let secondControl = ActionableControlWithBodyAndTitle(attributedTitle: secondTitle, attributedBodyText: secondBodyText, iconInBody: .pencil, isFilled: true)
        
        let thirdTitle = NSAttributedString(string: "About your education", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let thirdBodyText = NSMutableAttributedString(string: "Proof of being a student\nnot available yet", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
        thirdBodyText.setAttributeTo(part: "being a student", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16)])
        thirdBodyText.setAttributeTo(part: "not available yet", attributes: [.font: UIFont.sourceSansProLight(size: 12)])
        let thirdControl = ActionableControlWithBodyAndTitle(attributedTitle: thirdTitle, attributedBodyText: thirdBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: false)
        
        let institutionControl = ActionableControlWithCollapsibleBody(role: .employee, institution: "uva.nl", verifiedAt: Date(), affiliation: "Universiteit", expires: Date())
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, firstControl, secondControl, thirdControl, institutionControl, spaceView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        scrollView.addSubview(stack)
        
        // - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: -24))
        stack.width(to: scrollView, offset: -48)
        textLabel.width(to: stack)
        posterLabel.width(to: stack)
        firstControl.width(to: stack)
        secondControl.width(to: stack)
        thirdControl.width(to: stack)
        institutionControl.width(to: stack)
    }
    
    @objc
    func dismissInfoScreen() {
        delegate?.personalInfoViewControllerDismissPersonalInfoFlow(viewController: self)
    }
}
