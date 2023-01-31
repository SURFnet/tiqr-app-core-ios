import UIKit
import TinyConstraints

class EnterPersonalInfoViewController: EduIDBaseViewController, ValidatedTextFieldDelegate {
    
    var stack: AnimatedVStackView!
    let requestButton = EduIDButton(type: .primary, buttonTitle: "Request you eduID")
    
    var validationMap: [Int: Bool] = [0:false, 1:false, 2: false] {
        didSet {
            var isTrue = true
            validationMap.forEach({ (key: Int, value: Bool) in
                if !value {
                    isTrue = false
                }
            })
            requestButton.isEnabled = isTrue
        }
    }
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stack.animate(onlyThese: [1, 2, 3, 4, 6])
    }
    
    private func setupUI() {
        
        //MARK: - poster text
        let posterLabel = UILabel.posterTextLabel(text: "Request your eduID", size: 24)
        
        //MARK: - email
        let emailField = TextStackViewWithValidation(title: "Your email address", placeholder: "e.g. timbernerslee@gmail.com", keyboardType: .emailAddress)
        emailField.tag = 0
        emailField.delegate = self
        
        //MARK: - firstname
        let firstNameField = TextStackViewWithValidation(title: "First name", placeholder: "e.g. Tim", keyboardType: .default)
        firstNameField.tag = 1
        firstNameField.delegate = self
        
        //MARK: - lastName
        let lastNameField = TextStackViewWithValidation(title: "Last name", placeholder: "e.g. Berners-Lee", keyboardType: .default)
        lastNameField.tag = 2
        lastNameField.delegate = self
        
        //MARK: - check terms
        let termsHstack = UIStackView()
        termsHstack.spacing = 10
        termsHstack.axis = .horizontal
        termsHstack.height(36)
        
        let theSwitch = UISwitch()
        theSwitch.onTintColor = .primaryColor
        let termsLabel = UILabel()
        termsLabel.font = .sourceSansProRegular(size: 12)
        termsLabel.textColor = .charcoalColor
        termsLabel.numberOfLines = 2
        termsLabel.text = "I agree with the terms of service. I also understand the privacy policy."
        
        termsHstack.addArrangedSubview(theSwitch)
        termsHstack.addArrangedSubview(termsLabel)
        
        //MARK: - spacing
        let spacingView = UIView()
        spacingView.height(300, priority: .defaultLow)
        
        //MARK: - requestButton
        requestButton.isEnabled = false
        requestButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, emailField, firstNameField, lastNameField, termsHstack, spacingView, requestButton])
        stack.spacing = 32
        stack.setCustomSpacing(0, after: emailField)
        stack.setCustomSpacing(0, after: firstNameField)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .top
        
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        
        posterLabel.height(34)
        requestButton.width(to: stack, offset: -24)
        emailField.width(to: stack)
        firstNameField.width(to: stack)
        lastNameField.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [1, 2, 3, 4, 6])
    }
    
    //MARK: - textfield delegate
    func updateValidation(with value: Bool, from tag: Int) {
        validationMap[tag] = value
    }
    
    func keyBoardDidReturn(tag: Int) {
        guard tag != 2 else {
            resignKeyboardResponder()
            return
        }
        _ = (stack.arrangedSubviews[tag + 2] as? TextStackViewWithValidation)?.becomeFirstResponder()
    }
    
    @objc
    func resignKeyboardResponder() {
        (1...3).forEach { integer in
            _ = (stack.arrangedSubviews[integer] as? TextStackViewWithValidation)?.resignFirstResponder()
        }
    }
    
}
