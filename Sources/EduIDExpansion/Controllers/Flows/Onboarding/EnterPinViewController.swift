import UIKit
import TinyConstraints

class EnterPinViewController: OnBoardingBaseViewController, ScreenWithScreenType {
    
    //MARK: - screen type
    var screenType: ScreenType = .addInstitutionScreen

    //MARK: viewmodel
    let viewModel: EnterPinViewModel
    //MARK: verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify this pin code")
    //MARK: pin stack view
    let pinStack = AnimatedHStackView()
    //MARK: activity indicator
    let activity = UIActivityIndicatorView(style: .large)

    //MARK: - init
    init(viewModel: EnterPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
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
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(goBack))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _ = (pinStack.arrangedSubviews.first as? PinTextFieldView)?.becomeFirstResponder()
    }
    
    //MARK: - setup ui
    func setupUI() {
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Check your messages", size: 24)
        
        //MARK: - create the textView
        let textLabelParent = UIView()
        let textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.isUserInteractionEnabled = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .sourceSansProLight(size: 16)
        textLabel.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
Enter the six-digit code we sent to your phone to continue
"""
                                                ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        attributedText.setAttributes([.font : UIFont.sourceSansProSemiBold(size: 16)], range: NSRange(location: 10, length: 9))
        textLabel.attributedText = attributedText
        textLabelParent.addSubview(textLabel)
        textLabel.edges(to: textLabelParent)
        
        //MARK: pin fields
        
        pinStack.axis = .horizontal
        pinStack.distribution = .equalSpacing
        pinStack.height(50)
        
        (0...5).forEach { integer in
            let pinField = PinTextFieldView()
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
        let stack = UIStackView(arrangedSubviews: [posterLabel, textLabelParent, pinStack, activity, spaceView, verifyButton])
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
