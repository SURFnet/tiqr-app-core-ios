import UIKit
import TinyConstraints

class CheckEmailViewController: OnBoardingBaseViewController {
    
    //MARK: - delegate
    weak var navDelegate: NavigationDelegate?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenType = .checkMailScreen
        
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.showNextScreen()
        })
    }
    
    //MARK: - setup UI
    func setupUI() {
        
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Check your email", size: 24)
        
        //MARK: - messageLabel
        let messageLabel = UILabel.plainTextLabelPartlyBold(text: "To sign in, click the link in the email we sent to juanCarlos02@hotmail.com.", partBold: "juanCarlos02@hotmail.com.")
        let messageParent = UIView()
        messageParent.addSubview(messageLabel)
        messageLabel.edges(to: messageParent)
        
        //MARK: - activityIndicatorView
        let activity = UIActivityIndicatorView(style: .large)
        activity.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        activity.tintColor = .gray
        activity.width(100)
        activity.height(100)
        activity.startAnimating()
        
        //MARK: - email options buttons
        let gmailImage = UIImageView(image: .gmail)
        gmailImage.width(30)
        gmailImage.height(30)
        gmailImage.contentMode = .scaleAspectFit
        let gmailButton = UIButton()
        gmailButton.setAttributedTitle(NSAttributedString(string: "check gmail", attributes: [.font: UIFont.sourceSansProSemiBold(size: 18), .foregroundColor: UIColor.secondaryColor]), for: .normal)
        let gmailStack = UIStackView(arrangedSubviews: [gmailImage, gmailButton])
        gmailStack.alignment = .center
        gmailStack.spacing = 8
        
        let outlookImage = UIImageView(image: .outlook)
        outlookImage.width(30)
        outlookImage.height(30)
        outlookImage.contentMode = .scaleAspectFit
        let outlookButton = UIButton()
        outlookButton.contentMode = .scaleAspectFit
        outlookButton.setAttributedTitle(NSAttributedString(string: "check outlook", attributes: [.font: UIFont.sourceSansProSemiBold(size: 18), .foregroundColor: UIColor.secondaryColor]), for: .normal)
        let outlookStack = UIStackView(arrangedSubviews: [outlookImage, outlookButton])
        outlookStack.alignment = .center
        outlookStack.spacing = 8
        
        let emailOptionsVStack = UIStackView(arrangedSubviews: [gmailStack, outlookStack])
        emailOptionsVStack.axis = .vertical
        emailOptionsVStack.alignment = .leading
        emailOptionsVStack.spacing = 10
        
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterLabel, messageParent, activity, emailOptionsVStack, spaceView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.height(34)

    }
    
    @objc
    func goBackNav() {
        navDelegate?.goBack()
    }
}
