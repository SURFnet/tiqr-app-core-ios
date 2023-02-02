import UIKit
import TinyConstraints

class EnterPersonalInfoViewController: OnBoardingBaseViewController, ScreenWithScreenType {
    
    private var viewModel: EnterPersonalInfoViewModel
    private var keyboardHeight: CGFloat?
    private var isKeyBoardOnScreen = false
    private let inset: CGFloat = 24
    static let smallBuffer: CGFloat = 50
    static let emailFieldTag = 3
    
    var stack: AnimatedVStackView!
    let requestButton = EduIDButton(type: .primary, buttonTitle: "Request you eduID")
    let emailField = TextStackViewWithValidation(title: "Your email address", placeholder: "e.g. timbernerslee@gmail.com", keyboardType: .emailAddress)
    let scrollView = UIScrollView()
    
    //MARK: - screen type
    var screenType: ScreenType = .enterInfoScreen
    
    //MARK: - spacing
    let spacingView = UIView()
    
    
    //MARK: - init
    init(viewModel: EnterPersonalInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.makeNextTextFieldFirstResponderClosure = { [weak self] tag in
            guard tag != EnterPersonalInfoViewController.emailFieldTag else {
                self?.resignKeyboardResponder()
                return
            }
            //tag + 2 because the stackview's first subview is the poster label and we need the subview after the current, hence + 2
            _ = (self?.stack.arrangedSubviews[tag + 1] as? TextStackViewWithValidation)?.becomeFirstResponder()
            self?.scrollViewToTextField(index: tag + 1)
        }
        
        viewModel.setRequestButtonEnabled = { [weak self] isEnabled in
            self?.requestButton.isEnabled = isEnabled
        }
        
        viewModel.textFieldBecameFirstResponderClosure = { [weak self] tag in
            self?.scrollViewToTextField(index: tag)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignKeyboardResponder)))
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stack.animate(onlyThese: [1, 2, 3, 4, 6])
        _ = emailField.becomeFirstResponder()
        
        screenType.configureNavigationItem(item: navigationItem, target: self, action: #selector(goBack))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //set the height of the spacer according to the view
        if scrollView.frame.size.height > scrollView.contentSize.height + EnterPersonalInfoViewController.smallBuffer {
            spacingView.height(scrollView.frame.size.height - scrollView.contentSize.height - inset - view.safeAreaInsets.top)
        }
    }
    
    private func setupUI() {
        //MARK: add scrollview to hierarchy
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.edges(to: view)
        
        
        //MARK: - poster text
        let posterLabel = UILabel.posterTextLabel(text: "Request your eduID", size: 24)
        
        //MARK: - email
        emailField.tag = 1
        emailField.delegate = viewModel
        
        //MARK: - firstname
        let firstNameField = TextStackViewWithValidation(title: "First name", placeholder: "e.g. Tim", keyboardType: .default)
        firstNameField.tag = 2
        firstNameField.delegate = viewModel
        
        //MARK: - lastName
        let lastNameField = TextStackViewWithValidation(title: "Last name", placeholder: "e.g. Berners-Lee", keyboardType: .default)
        lastNameField.tag = 3
        lastNameField.delegate = viewModel
        
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
        
        //MARK: - requestButton
        requestButton.isEnabled = false
        requestButton.addTarget(self, action: #selector(showNextScreen), for: .touchUpInside)
        
        //MARK: - create the stackview
        stack = AnimatedVStackView(arrangedSubviews: [posterLabel, emailField, firstNameField, lastNameField, termsHstack, spacingView, requestButton])
        stack.spacing = 32
        stack.setCustomSpacing(24, after: emailField)
        stack.setCustomSpacing(24, after: firstNameField)
        stack.setCustomSpacing(4, after: lastNameField)
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        
        scrollView.addSubview(stack)
        
        //MARK: - add constraints
        stack.edges(to: scrollView, insets: TinyEdgeInsets(top: inset, left: inset, bottom: inset, right: -inset))
        stack.width(to: scrollView, offset: -(2 * inset))
        
        posterLabel.height(34)
        requestButton.width(to: stack, offset: -inset)
        emailField.width(to: stack)
        firstNameField.width(to: stack)
        lastNameField.width(to: stack)
        
        stack.hideAndTriggerAll(onlyThese: [1, 2, 3, 4, 6])
    }
    
    //MARK: - keyboard related
    
    @objc
    func keyboardDidShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        keyboardHeight = keyboardFrame.size.height
        guard !isKeyBoardOnScreen else {
            return
        }
        isKeyBoardOnScreen = true
        for (i, arrangedSubview) in stack.arrangedSubviews.enumerated() {
            if let textView = arrangedSubview as? TextStackViewWithValidation {
                if textView.textField.isFirstResponder {
                    scrollViewToTextField(index: i)
                }
            }
        }
    }
    
    @objc
    func keyboardDidHide() {
        isKeyBoardOnScreen = false
        resetScrollviewInsets()
    }
    
    func resetScrollviewInsets() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.scrollView.contentInset.bottom = 0
            self?.scrollView.contentOffset.y = -(self?.view.safeAreaInsets.top ?? 0)
        }
    }
    
    func scrollViewToTextField(index: Int) {
        let stackHeight = stack.frame.size.height
        let textFieldFrameInWindow = stack.arrangedSubviews[index].convert(stack.arrangedSubviews[index].bounds, to: view.window)
        let textFieldOriginY = textFieldFrameInWindow.origin.y
        let textFieldHeight = textFieldFrameInWindow.size.height
        let textFieldLowpoint = textFieldOriginY + textFieldHeight
        let distanceFromBottomToTextField = scrollView.frame.size.height - textFieldLowpoint
                
        if distanceFromBottomToTextField < keyboardHeight ?? 0 {
            scrollView.contentInset.bottom = (keyboardHeight ?? 0) - distanceFromBottomToTextField
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.scrollView.contentOffset.y = -(self?.view.safeAreaInsets.top ?? 0) + (self?.keyboardHeight ?? 0) - distanceFromBottomToTextField
            }
        } 
    }
    
    @objc
    func resignKeyboardResponder() {
        (1...3).forEach { integer in
            _ = (stack.arrangedSubviews[integer] as? TextStackViewWithValidation)?.resignFirstResponder()
        }
    }
    
}
