import UIKit
import TinyConstraints

class PincodeBaseViewController: OnBoardingBaseViewController {
    
    //MARK: viewmodel
    let viewModel: EnterPinViewModel
    //MARK: verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify this pin code")
    //MARK: pin stack view
    let pinStack = AnimatedHStackView()
    //MARK: activity indicator
    let activity = UIActivityIndicatorView(style: .large)
    
    //MARK: - configurable labels
    var posterLabel: UILabel!
    var textLabel: UILabel!
    
    // flag for secure input
    var isSecure = false
    

    //MARK: - init
    init(viewModel: EnterPinViewModel, isSecure: Bool) {
        self.isSecure = isSecure
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        screenType = .pinChallengeScreen
        
        viewModel.focusPinField = { [weak self] tag in
            (self?.pinStack.arrangedSubviews[tag + 1] as? PinTextFieldView)?.focus()
        }
        
        viewModel.enableVerifyButton = { [weak self] isEnabled in
            self?.verifyButton.isEnabled = isEnabled
        }
        
        viewModel.resignKeyboardFocus = { [weak self] in
            self?.resignKeyboardFocus()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        verifyButton.isEnabled = false
        verifyButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardFocus)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pinStack.animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = (pinStack.arrangedSubviews.first as? PinTextFieldView)?.becomeFirstResponder()
    }
    
    //MARK: - setup ui
    func setupUI() {
        //MARK: - posterLabel
        let posterParent = UIView()
        posterLabel = UILabel.posterTextLabel(text: "Check your messages", size: 24)
        posterParent.addSubview(posterLabel)
        posterLabel.edges(to: posterParent)
        
        //MARK: - create the textView
        let textLabelParent = UIView()
        textLabel = UILabel.plainTextLabelPartlyBold(text: """
Enter the six-digit code we sent to your phone to continue
"""
                                                         , partBold: "six-digit")
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        //MARK: pin fields
        
        pinStack.axis = .horizontal
        pinStack.distribution = .equalSpacing
        pinStack.height(50)
        
        (0...5).forEach { integer in
            let pinField = PinTextFieldView(isSecure: isSecure)
            pinField.tag = integer
            pinField.delegate = viewModel
            pinStack.addArrangedSubview(pinField)
        }
        
        //MARK: - activityIndicatorView
        activity.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        activity.tintColor = .gray
        activity.width(100)
        activity.height(100)
        
        
        //MARK: - Space
        let spaceView = UIView()
        
        //MARK: - create the stackview
        let stack = UIStackView(arrangedSubviews: [posterParent, textLabelParent, pinStack, activity, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textLabel.width(to: stack)
        posterLabel.height(34)
        posterParent.width(to: stack)
        verifyButton.width(to: stack, offset: -24)
        pinStack.width(to: stack)
        
        pinStack.hideAndTriggerAll()
    }
    
    //MARK: - gesture action resign keyboard focus
    @objc
    func resignKeyboardFocus() {
        pinStack.arrangedSubviews.forEach { pinview in
            pinview.resignFirstResponder()
        }
    }
}
