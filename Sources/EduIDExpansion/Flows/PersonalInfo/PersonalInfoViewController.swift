import UIKit
import TinyConstraints

class PersonalInfoViewController: UIViewController, ScreenWithScreenType {
   
    // - screen type
    var screenType: ScreenType = .personalInfoLandingScreen
    
    // - delegate
    weak var delegate: PersonalInfoViewControllerDelegate?
    
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(dismissInfoScreen))
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        // - scroll view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        // - posterLabel
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Your personal info", size: 24, primary: "Your personal info")
        
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
        let firstBodyText = NSMutableAttributedString(string: "Your full name", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.backgroundColor])
        firstBodyText.setAttributeTo(part: "full name", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor])
        let firstControl = ActionableControlWithBodyAndTitle(attributedTitle: firstTitle, attributedBodyText: firstBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        let secondBodyText = NSMutableAttributedString(string: "Your email address", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.backgroundColor])
        secondBodyText.setAttributeTo(part: "email address", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor])
        let secondControl = ActionableControlWithBodyAndTitle(attributedBodyText: secondBodyText, iconInBody: UIImage(systemName: "chevron.right"), isFilled: true)
        
        let thirdTitle = NSAttributedString(string: "About your education", attributes: [.font : UIFont.sourceSansProBold(size: 16), .foregroundColor: UIColor.charcoalColor])
        let thirdBodyText = NSMutableAttributedString(string: "Proof of being a student\nnot available yet", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.charcoalColor])
        thirdBodyText.setAttributeTo(part: "being a student", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16)])
        thirdBodyText.setAttributeTo(part: "not available yet", attributes: [.font: UIFont.sourceSansProLight(size: 12)])
        let thirdControl = ActionableControlWithBodyAndTitle(attributedTitle: thirdTitle, attributedBodyText: thirdBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: false)
        
        let fourthBodyText = NSMutableAttributedString(string: "Your link to a school/uni", attributes: [.font: UIFont.sourceSansProRegular(size: 16), .foregroundColor: UIColor.backgroundColor])
        fourthBodyText.setAttributeTo(part: "link to a school/uni", attributes: [.font: UIFont.sourceSansProSemiBold(size: 16), .foregroundColor: UIColor.backgroundColor])
        let fourthControl = ActionableControlWithBodyAndTitle(attributedBodyText: fourthBodyText, iconInBody: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), isFilled: true)
        
        // - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, firstControl, secondControl, thirdControl, fourthControl, spaceView])
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
        fourthControl.width(to: stack)
    }
    
    @objc
    func dismissInfoScreen() {
        delegate?.personalInfoViewControllerDismissPersonalInfoFlow(viewController: self)
    }
}
