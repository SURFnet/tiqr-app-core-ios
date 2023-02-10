import UIKit
import TinyConstraints
import Combine

class TextFieldViewWithValidationAndTitle: UIStackView, UITextFieldDelegate {
    
    private let validLabel = UILabel()
    private let extraBorderView = UIView()
    let textField = UITextField()
    weak var delegate: ValidatedTextFieldDelegate?
    
    //MARK: - cancellables
    var cancellables = Set<AnyCancellable>()

    //MARK: init
    init(regex: String? = nil, title: String, placeholder: String, keyboardType: UIKeyboardType, isPassword: Bool = false) {
        super.init(frame: .zero)
        
        extraBorderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        axis = .vertical
        spacing = 6
        
        //MARK: - title
        let label = UILabel()
        label.height(16)
        label.font = .sourceSansProSemiBold(size: 16)
        label.textColor = .charcoalColor
        label.text = title
        addArrangedSubview(label)
        
        //MARK: - textfield
        
        textField.font = .sourceSansProRegular(size: 16)
        textField.placeholder = placeholder
        textField.delegate = self
        textField.height(20)
        textField.keyboardType = keyboardType
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .continue
        
        textField.isSecureTextEntry = isPassword
        
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: textField)
            .map( {
                ($0.object as? UITextField)?.text
            })
        
        textFieldPublisher
            .receive(on: RunLoop.main)
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.validateText()
            })
            .store(in: &cancellables)

        //MARK: - textfield border
        extraBorderView.layer.borderWidth = 2
        extraBorderView.layer.borderColor = UIColor.clear.cgColor
        extraBorderView.layer.cornerRadius = 8
        let textFieldParent = UIView()
        extraBorderView.addSubview(textFieldParent)
        addArrangedSubview(extraBorderView)
        extraBorderView.width(to: self)
        extraBorderView.height(52)
        textFieldParent.height(48)
        textFieldParent.center(in: extraBorderView)
        textFieldParent.leading(to: extraBorderView, offset: 2)
        textFieldParent.trailing(to: extraBorderView, offset: -2)
        textFieldParent.layer.cornerRadius = 6
        textFieldParent.layer.borderWidth = 1
        textFieldParent.layer.borderColor = UIColor.tertiaryColor.cgColor
        textFieldParent.addSubview(textField)
        textField.center(in: textFieldParent)
        textField.width(to: self, offset: -24)
        
        //MARK: - validationMessage
        validLabel.font = .sourceSansProSemiBold(size: 12)
        validLabel.height(12)
        validLabel.textColor = .red
        validLabel.text = "The input doesn't follow regex"
        validLabel.alpha = 0
        addArrangedSubview(validLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - textfield validation
    func validateText() {
        if textField.text?.count ?? 0 < 3 || textField.text?.count ?? 0 > 20 {
            validLabel.alpha = 1
            delegate?.updateValidation(with: false, from: tag)
        } else {
            validLabel.alpha = 0
            delegate?.updateValidation(with: true, from: tag)
        }
    }
    
    //MARK: - texfield delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        extraBorderView.layer.borderColor = UIColor.textfieldFocusColor.cgColor
        delegate?.didBecomeFirstResponder(tag: tag)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        extraBorderView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.keyBoardDidReturn(tag: tag)
        return true
    }
    
    //MARK: - deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - keyboard responder
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc
    func tapped() {
        textField.becomeFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
}

protocol ValidatedTextFieldDelegate: AnyObject {
    
    func updateValidation(with value: Bool, from tag: Int)
    func keyBoardDidReturn(tag: Int)
    func didBecomeFirstResponder(tag: Int)
}
