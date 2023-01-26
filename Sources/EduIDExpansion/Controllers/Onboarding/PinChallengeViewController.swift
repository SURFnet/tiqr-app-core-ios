import UIKit
import TinyConstraints

class PinChallengeViewController: EduIDBaseViewController, PinTextFieldDelegate {

    //MARK: - verify button
    let verifyButton = EduIDButton(type: .primary, buttonTitle: "Verify this pin code")
    //MARK: - pinstackview
    let pinStack = AnimatedHStackView()
    //MARK: activity indicator
    let activity = UIActivityIndicatorView(style: .large)

    
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
    func setupUI() {
        //MARK: - posterLabel
        let posterLabel = UILabel.posterTextLabel(text: "Check your messages", size: 24)
        
        //MARK: - create the textView
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .sourceSansProLight(size: 16)
        textView.textColor = .secondaryColor
        let attributedText = NSMutableAttributedString(string:
"""
Enter the six-digit code we sent to your phone to continue
"""
                                                ,attributes: [.font : UIFont.sourceSansProLight(size: 16)])
        attributedText.setAttributes([.font : UIFont.sourceSansProSemiBold(size: 16)], range: NSRange(location: 10, length: 9))
        textView.attributedText = attributedText
        
        //MARK: pin fields
        
        pinStack.axis = .horizontal
        pinStack.distribution = .equalSpacing
        pinStack.height(50)
        
        (0..<6).forEach { integer in
            let pinField = PinTextFieldView()
            pinField.tag = integer
            pinField.delegate = self
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
        let stack = UIStackView(arrangedSubviews: [posterLabel, textView, pinStack, activity, spaceView, verifyButton])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 32
        view.addSubview(stack)
        
        //MARK: - add constraints
        stack.edgesToSuperview(insets: TinyEdgeInsets(top: 24, left: 24, bottom: 24, right: 24), usingSafeArea: true)
        textView.width(to: stack)
        textView.height(80)
        posterLabel.height(34)
        verifyButton.width(to: stack, offset: -24)
        pinStack.width(to: stack)
        
        pinStack.hideAndTriggerAll()
    }
    
    //MARK: pin textfield delegate
    func didEnterPinNumber(tag: Int) {
        if tag == 5 {
            resignKeyboardFocus()
            verifyButton.isEnabled = true
        } else {
            (pinStack.arrangedSubviews[tag + 1] as? PinTextFieldView)?.focus()
        }
    }
    
    //MARK: - gesture method resign keyboard focus
    @objc
    func resignKeyboardFocus() {
        pinStack.arrangedSubviews.forEach { pinview in
            pinview.resignFirstResponder()
        }
    }
}
