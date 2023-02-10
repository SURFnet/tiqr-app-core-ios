import UIKit
import TinyConstraints

class SecurityEnterEmailViewController: UIViewController, ScreenWithScreenType, ValidatedTextFieldDelegate {

    //MARK: - screen type
    var screenType: ScreenType = .addInstitutionScreen
    
    //MARK: - delegate
    weak var delegate: SecurityViewControllerDelegate?
    
    var stack: AnimatedVStackView!
    
    //MARK: - phone textfield
    let validatedEmailTextField = TextFieldViewWithValidationAndTitle(title: "Your new email address", placeholder: "e.g. jairo@egeniq.com", keyboardType: .emailAddress)
    
    //MARK: - verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify email address")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        verifyButton.addTarget(self, action: #selector(verifyEmail), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stack.animate(onlyThese: [2])
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(goBack))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = validatedEmailTextField.becomeFirstResponder()
    }
    
    func setupUI() {
        
        //MARK: - phone textfield delegate
        validatedEmailTextField.delegate = self
        
        //MARK: - button state
        verifyButton.isEnabled = false
        
        //MARK: - posterLabel
        let posterParent = UIView()
        let posterLabel = UILabel.posterTextLabelBicolor(text: "Email", size: 24, primary: "Email", alignment: .left)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        //MARK: - textView Parent
        let textViewParent = UIView()
        
        //MARK: - create the textView
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .sourceSansProLight(size: 16)
        textLabel.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
Please enter your new email address. A verification mail will be sent to this address.
"""
                                                ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        textLabel.attributedText = attributedText
        
        textViewParent.addSubview(textLabel)
        textLabel.edges(to: textViewParent)
        textLabel.sizeToFit()
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterParent, textViewParent, validatedEmailTextField, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textViewParent.width(to: stack)
        verifyButton.width(to: stack, offset: -24)
        validatedEmailTextField.width(to: stack)
        posterLabel.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [2])
    }
    
    //MARK: - textfield validation method
    func updateValidation(with value: Bool, from tag: Int) {
        verifyButton.isEnabled = value
    }
    
    func keyBoardDidReturn(tag: Int) {
        resignKeyboardResponder()
    }
    
    func didBecomeFirstResponder(tag: Int) {
    }
    
    @objc
    func resignKeyboardResponder() {
        _ = validatedEmailTextField.resignFirstResponder()
    }
    
    @objc
    func goBack() {
        delegate?.goBack(viewController: self)
    }
    
    @objc
    func verifyEmail() {
        delegate?.securityViewController(viewController: self, verify: "")
    }

}
